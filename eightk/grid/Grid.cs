using Godot;
using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

namespace EightK {
	public partial class Grid : Node2D {
		private const bool FORCE_RELEASE = true;

		[Signal]
		public delegate void OnScoreChangedEventHandler(int score);

		[Signal]
		public delegate void OnGameOverEventHandler();

		private PackedScene tileScene;

		private Tile[,] grid;
		private int gridSize = 4;
		private int tileSize = 128;

		public override void _Ready() {
			tileScene = GD.Load<PackedScene>("res://tiles/tile.tscn");
			grid = new Tile[gridSize, gridSize];
			PopulateStartingTiles();
			PrintGrid();
		}


		public override void _Process(double delta) {
		}

		public override void _Input(InputEvent @event) {
			Vector2 direction = Input.GetVector("slide_left", "slide_right", "slide_up", "slide_down");
			if (direction != Vector2.Zero) {
				// Force to cardinal direction by taking the larger component
				if (Math.Abs(direction.X) > Math.Abs(direction.Y)) {
					direction = new Vector2(Math.Sign(direction.X), 0);
				} else {
					direction = new Vector2(0, Math.Sign(direction.Y));
				}
				bool movementOccurred = MoveTiles(direction);
				if (movementOccurred) {
					SpawnRandomTile();
				}

				if (IsGameOver() || OS.IsDebugBuild() && !FORCE_RELEASE) {
					EmitSignal(SignalName.OnGameOver);
				}

				PrintGrid();
			}
		}

		public void Reset() {
			foreach (var tile in GetNode<Node2D>("Tiles").GetChildren()) {
				if (IsInstanceValid(tile)) {
					tile.QueueFree();
				}
			}
			PopulateStartingTiles();
			PrintGrid();
		}

		private void PopulateStartingTiles() {
			Random random = new();
			Vector2 tile1Position = new(random.Next(0, gridSize), random.Next(0, gridSize));
			Vector2 tile2Position;
			do {
				tile2Position = new Vector2(random.Next(0, gridSize), random.Next(0, gridSize));
			} while (tile2Position == tile1Position);
			
			Tile tile1 = tileScene.Instantiate<Tile>();
			GetNode<Node2D>("Tiles").AddChild(tile1);
			tile1.Position = tile1Position * tileSize;
			tile1.Value = 2;
			grid[(int)tile1Position.X, (int)tile1Position.Y] = tile1;

			Tile tile2 = tileScene.Instantiate<Tile>();
			GetNode<Node2D>("Tiles").AddChild(tile2);
			tile2.Position = tile2Position * tileSize;
			tile2.Value = 2;
			grid[(int)tile2Position.X, (int)tile2Position.Y] = tile2;
		}

		private bool MoveTiles(Vector2 direction) {
			bool movementOccurred = false;
			bool isHorizontal = direction.X != 0;
			bool isReverse = direction.X < 0 || direction.Y < 0;

			Dictionary<Tile, Vector2> tilesToMerge = [];

			GD.Print($"MoveTiles direction: {direction}, isHorizontal: {isHorizontal}, isReverse: {isReverse}");

			int pointsScored = 0;
   
			for (int i = 0; i < gridSize; i++) {
				// Tiles to move in this row or column
				Stack<Tile> tilesToMove = new();

				for (int j = 0; j < gridSize; j++) {
					int x = isHorizontal ? (isReverse ? gridSize - 1 - j : j) : i;
					int y = isHorizontal ? i : (isReverse ? gridSize - 1 - j : j);
					Tile tile = grid[x, y];
					if (tile != null) {
						// Store the tile to move and remove it from the grid
						tilesToMove.Push(tile);
						grid[x, y] = null;
					}
				}

				int newIndex = isReverse ? 0 : gridSize - 1;
				while (tilesToMove.Count > 0) {
					Tile currentTile = tilesToMove.Pop();
					Tile nextTile = tilesToMove.Count > 0 ? tilesToMove.Peek() : null;
					Tile mergedTile = null;

					// If the next tile has the same value, merge them
					if (nextTile != null && nextTile.Value == currentTile.Value) {
						mergedTile = nextTile;
						tilesToMove.Pop();
						currentTile.Value *= 2;
						pointsScored += currentTile.Value;
					}
					Vector2I newPos = new(isHorizontal ? newIndex : i, isHorizontal ? i : newIndex);
					Vector2I oldPos = new((int)currentTile.Position.X / tileSize, (int)currentTile.Position.Y / tileSize);
					if (newPos != oldPos) {
						movementOccurred = true;
					}
					grid[newPos.X, newPos.Y] = currentTile;
					if (mergedTile != null) {
						tilesToMerge.Add(mergedTile, new Vector2(newPos.X, newPos.Y));

						// Merging a tile is also a movement
						movementOccurred = true;
					}
					newIndex += isReverse ? 1 : -1;
				}
			}

			// Animate the tiles moving
			for (int x = 0; x < gridSize; x++) {
				for (int y = 0; y < gridSize; y++) {
					Tile tile = grid[x, y];
					if (tile != null) {
						Tween tween = tile.CreateTween();
						tween.TweenProperty(tile, "position", new Vector2(x, y) * tileSize, 0.1f);
					}
				}
			}

			// Animate the tiles merging
			foreach (var (tile, position) in tilesToMerge) {
				Tween tween = tile.CreateTween();
				tween.TweenProperty(tile, "position", position * tileSize, 0.1f);
				tween.TweenProperty(tile, "modulate", new Color(1, 1, 1, 0), 0.05f);
				tween.TweenCallback(Callable.From(() => {
					tile.QueueFree();
				}));
			}

			EmitSignal(SignalName.OnScoreChanged, pointsScored);

			return movementOccurred;
		}

		private void SpawnRandomTile() {
			List<Vector2I> emptyCells = [];
			for (int i = 0; i < gridSize; i++) {
				for (int j = 0; j < gridSize; j++) {
					if (grid[i, j] == null && (i == 0 || i == gridSize - 1 || j == 0 || j == gridSize - 1)) {
						emptyCells.Add(new Vector2I(i, j));
					}
				}
			}

			if (emptyCells.Count > 0) {
				Random random = new();
				int randomIndex = random.Next(0, emptyCells.Count);
				Vector2I randomCell = emptyCells[randomIndex];
				SpawnTile(randomCell);
			}
		}

		private void SpawnTile(Vector2 position) {
			Random random = new();
			Tile tile = tileScene.Instantiate<Tile>();
			GetNode<Node2D>("Tiles").AddChild(tile);
			tile.Position = position * tileSize;
			tile.PlaySpawnAnimation();
			int spawnValue = 2;
			if (random.Next(0, 10) > 7) {
				spawnValue = 4;
			}
			if (OS.IsDebugBuild() && !FORCE_RELEASE) {
				spawnValue = 512;
			}
			tile.Value = spawnValue;
			grid[(int)position.X, (int)position.Y] = tile;
		}

		private bool IsGameOver() {
			for (int i = 0; i < gridSize; i++) {
				for (int j = 0; j < gridSize; j++) {
					if (grid[i, j] == null) {
						return false;
					} else {
						var adjacentTiles = GetAdjacentTiles(new Vector2I(i, j));
						foreach (var tile in adjacentTiles) {
							if (tile.Value == grid[i, j].Value) {
								return false;
							}
						}
					}
				}
			}
			GD.Print("Game over");
			return true;
		}

		private List<Tile> GetAdjacentTiles(Vector2I position) {
			List<Tile> adjacentTiles = [];
			if (position.X > 0) {
				adjacentTiles.Add(grid[position.X - 1, position.Y]);
			}
			if (position.X < gridSize - 1) {
				adjacentTiles.Add(grid[position.X + 1, position.Y]);
			}
			if (position.Y > 0) {
				adjacentTiles.Add(grid[position.X, position.Y - 1]);
			}
			if (position.Y < gridSize - 1) {
				adjacentTiles.Add(grid[position.X, position.Y + 1]);
			}
			return [.. adjacentTiles.Where(tile => tile != null)];
		}

		private void PrintGrid() {
			for (int i = 0; i < gridSize; i++) {
				StringBuilder row = new();
				for (int j = 0; j < gridSize; j++) {
					row.Append((grid[j, i] != null ? grid[j, i].Value.ToString() : " - ").PadRight(4));
				}
				GD.Print(row.ToString());
			}
		}
	}
}