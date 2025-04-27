using Godot;
using System;

namespace Tiles {
	public partial class Tile : Polygon2D {
		const float TILE_SPAWN_OFFSET_X = (128 - 16) / 2;
		const float TILE_SPAWN_OFFSET_Y = (128 - 8) / 2;
		const float SPAWN_ANIMATION_DURATION = 0.2f;

		private struct TileLayout {
			public Vector2 Scale;
			public Vector2 Position;
			public Color FontColor;
			public Color TileColor;
		}

		private static readonly TileLayout[] TILE_LAYOUTS = [
			new TileLayout { Scale = new Vector2(1.0f, 1.0f), Position = new Vector2(16.0f, 8.0f), FontColor = new Color(1.0f, 1.0f, 1.0f), TileColor = new Color(1.0f, 0.0f, 0.0f) },
			new TileLayout { Scale = new Vector2(0.8f, 0.8f), Position = new Vector2(24.0f, 16.0f), FontColor = new Color(0.0f, 1.0f, 0.0f), TileColor = new Color(1.0f, 1.0f, 1.0f) },
			new TileLayout { Scale = new Vector2(0.6f, 0.6f), Position = new Vector2(32.0f, 24.0f), FontColor = new Color(1.0f, 0.0f, 0.0f), TileColor = new Color(1.0f, 1.0f, 1.0f) }
		];

		private int _value;
		public int Value { 
			get => _value;
			set {
				_value = value;
				OnValueSet(value);
			}
		}

		private Label label;

		public override void _Ready() {
			label = GetNode<Label>("TileLabel");
		}

		private void OnValueSet(int value) {
			label.Text = value.ToString();
			
			int layoutIndex = 0;
			if (value > 99) layoutIndex = 1;
			if (value > 999) layoutIndex = 2;
			
			label.Scale = TILE_LAYOUTS[layoutIndex].Scale;
			label.Position = TILE_LAYOUTS[layoutIndex].Position;
			label.AddThemeColorOverride("font_color", TILE_LAYOUTS[layoutIndex].FontColor);

			this.Color = TILE_LAYOUTS[layoutIndex].TileColor;
		}

		public override void _Process(double delta) {
		}

		public void PlaySpawnAnimation() {
			// Set initial position to the center of the tile
			Scale = new Vector2(0.0f, 0.0f);
			Position = Position + new Vector2(TILE_SPAWN_OFFSET_X, TILE_SPAWN_OFFSET_Y);

			// Animate the tile to grow and move up
			// Need two tweens to allow the tile to grow and move up at the same time
			Tween scaleTween = CreateTween();
			scaleTween.TweenProperty(this, "scale", new Vector2(1.0f, 1.0f), SPAWN_ANIMATION_DURATION);

			Tween positionTween = CreateTween();
			positionTween.TweenProperty(this, "position", Position - new Vector2(TILE_SPAWN_OFFSET_X, TILE_SPAWN_OFFSET_Y), SPAWN_ANIMATION_DURATION);
		}

	}
}
