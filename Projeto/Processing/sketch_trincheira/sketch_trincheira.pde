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
  // BattleField
  pushMatrix();
  fill(150, 75, 0);
  translate(width/2, height/2, 0);
  rotateX(mouseX/float(width) * PI);
  rotateY(mouseY/float(height) * PI);
  box(400, 30, 600);
  popMatrix();
}

void drawBattleField() {
  pushMatrix();
  fill(150, 75, 0);
  translate(width/2, height/2, 0);
  rotateX(mouseX/float(width) * PI);
  rotateY(mouseY/float(height) * PI);
  box(400, 30, 600);
  popMatrix();
}

void drawSoldiers() {
  // Cabeça
  pushMatrix();
  fill(255, 95, 31);
  translate(480, 100, 0);
  rotateX(mouseX/float(width) * PI);
  rotateY(mouseY/float(height) * PI);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(255, 95, 31);
  translate(480, 100, 50);
  rotateX(mouseX/float(width) * PI);
  rotateY(mouseY/float(height) * PI);
  drawCylinder(100, 20, 6);
  popMatrix();
}

void drawCylinder(int sides, float r, float h)
{
    float angle = 360 / sides;
    float halfHeight = h / 2;
    // draw top shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, -halfHeight );    
    }
    endShape(CLOSE);
    // draw bottom shape
    beginShape();
    for (int i = 0; i < sides; i++) {
        float x = cos( radians( i * angle ) ) * r;
        float y = sin( radians( i * angle ) ) * r;
        vertex( x, y, halfHeight );    
    }
    endShape(CLOSE);
}

void drawGuns() {
  // Player 1's Gun
  pushMatrix();
  fill(255, 95, 31);
  translate(width/2 + 200, height/2 - 200, 100);
  rotateX(mouseX/float(width) * PI);
  rotateY(mouseY/float(height) * PI);
  box(50, 200, 50);
  popMatrix();

  pushMatrix();
  fill(255, 95, 31);
  translate(width/2 + 300, height/2 - 200, 0);
  rotateX(mouseX/float(width) * PI);
  rotateY(mouseY/float(height) * PI);
  box(50, -50, -200);
  popMatrix();

  // Player 2's Gun
  // pushMatrix();
  // fill(255, 95, 31);
  // translate(width/2, height/2, 0);
  // rotateX(-PI/6);
  // rotateY(PI/3);
  // box(50, 200, 50);
  // popMatrix();
}

void drawInvalidPositionText() {
  if(showInvalidPositionText) {
    fill(0);
    text("Posicionamento inválido. Tente novamente", 480, 100);
  }
}
