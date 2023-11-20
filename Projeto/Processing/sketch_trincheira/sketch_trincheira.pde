// Variaveis
PFont font;
boolean preparacao = true;
boolean showInvalidPositionText = false;

void setup() {
  size(1400, 900, P3D);
  font = createFont("Calibri", 24);
  textFont(font);
}

void draw() {
  background(204);
  camera(200, -400 + mouseY, -1000 + 2*mouseX, width/2, height/2, 0, 0, 1, 0);
  drawBattleField();
  drawSoldiers();
  drawGuns();
  drawInvalidPositionText();
}

void drawBattleField() {
  pushMatrix();
  fill(150, 75, 0);
  translate(width/2, height/2, 0);
  box(400, 30, 600);
  popMatrix();
}

void drawSoldiers() {
  // Cabeça
  pushMatrix();
  fill(29, 76, 184);
  translate(480, 100, 0);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(29, 76, 184);
  translate(480, 140, 0);
  box(20, 50, 20);
  popMatrix();
}

void drawGuns() {
  // Player 1's Gun
  pushMatrix();
  fill(255, 95, 31);
  translate(width/2, height/2 - 60, 360);
  box(50, 150, 50);
  popMatrix();

  pushMatrix();
  fill(255, 95, 31);
  translate(width/2, height/2 - 160, 310);
  box(50, -50, -150);
  popMatrix();

  // Player 2's Gun
  pushMatrix();
  fill(255, 95, 31);
  translate(width/2, height/2 - 60, -360);
  box(50, 150, 50);
  popMatrix();

  pushMatrix();
  fill(255, 95, 31);
  translate(width/2, height/2 - 160, -310);
  box(50, -50, 150);
  popMatrix();
}

void drawInvalidPositionText() {
  if(showInvalidPositionText) {
    fill(0);
    text("Posicionamento inválido. Tente novamente", 480, 100);
  }
}
