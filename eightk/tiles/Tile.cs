using Godot;
using System;

namespace Tiles {
	public partial class Tile : Polygon2D {
		private int _value;
		public int Value { 
			get => _value;
			set {
				_value = value;
				SetValue(value);
			}
		}

		private Label label;

		public override void _Ready() {
			label = GetNode<Label>("TileLabel");
		}

		private void SetValue(int value) {
			label.Text = value.ToString();
		}

		public override void _Process(double delta) {
		}


	}
}
