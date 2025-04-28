using Godot;
using System;

namespace EightK {
	public partial class Game : Node {
		private Label scoreLabel;
		private Grid grid;

		private Control gameOverScreen;

		private int score = 0;

		// Called when the node enters the scene tree for the first time.
		public override void _Ready() {
			scoreLabel = GetNode<Label>("UI/ScoreLabel");
			grid = GetNode<Grid>("Grid");
			gameOverScreen = GetNode<Control>("GameOverScreen");
		}

		public void AddScore(int amount) {
			GD.Print($"Adding {amount} points");
			score += amount;
			scoreLabel.Text = score.ToString();
		}

		public void ResetScore() {
			score = 0;
			scoreLabel.Text = score.ToString();
		}

		public void GameOver() {
			GetNode<Label>("GameOverScreen/Panel/GameOverScoreLabel").Text = $"Score: {score}";
			gameOverScreen.Visible = true;
		}

		public void Restart() {
			GetTree().ReloadCurrentScene();
		}
	}
}