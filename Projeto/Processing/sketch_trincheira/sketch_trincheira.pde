// Variaveis de controle e configuracao
PFont font;
boolean preparacao = true;
boolean vezJogadorUm = true;
boolean showInvalidPositionText = false;

// Variaveis de distancia e angulo dos soldados
int posXCabecaSoldado1Jog1 = 800;  // width/2 + 100
int posXCabecaSoldado2Jog1 = 700; // width/2
int posXCabecaSoldado3Jog1 = 600; // width/2 - 100
int posXCabecaSoldado1Jog2 = 800; // width/2 + 100
int posXCabecaSoldado2Jog2 = 700; // width/2
int posXCabecaSoldado3Jog2 = 600; // width/2 - 100
int posYCabecaSoldado1Jog1 = 370; // height/2 - 80
int posYCabecaSoldado2Jog1 = 370; // height/2 - 80
int posYCabecaSoldado3Jog1 = 370; // height/2 - 80
int posYCabecaSoldado1Jog2 = 370; // height/2 - 80
int posYCabecaSoldado2Jog2 = 370; // height/2 - 80
int posYCabecaSoldado3Jog2 = 370; // height/2 - 80
int posYCorpoSoldado1Jog1 = 410; // height/2 - 40
int posYCorpoSoldado2Jog1 = 410; // height/2 - 40
int posYCorpoSoldado3Jog1 = 410; // height/2 - 40
int posYCorpoSoldado1Jog2 = 410; // height/2 - 40
int posYCorpoSoldado2Jog2 = 410; // height/2 - 40
int posYCorpoSoldado3Jog2 = 410; // height/2 - 40
int distSoldado1Jog1 = 0;
int distSoldado2Jog1 = 0;
int distSoldado3Jog1 = 0;
int distSoldado1Jog2 = 0;
int distSoldado2Jog2 = 0;
int distSoldado3Jog2 = 0;
float rotateSoldado1Jog1 = 0;
float rotateSoldado2Jog1 = 0;
float rotateSoldado3Jog1 = 0;
float rotateSoldado1Jog2 = 0;
float rotateSoldado2Jog2 = 0;
float rotateSoldado3Jog2 = 0;

// Variaveis de angulo das armas
float rotateYArmaJog1 = 0;
float rotatezArmaJog1 = 0;
float rotateYArmaJog2 = 0;
float rotatezArmaJog2 = 0;

void setup() {
  size(1400, 900, P3D);
  font = createFont("Calibri", 24);
  textFont(font);
}

void draw() {
  background(204); 
  camera(constrain(1.55*abs(mouseX - 500), 0, 750), constrain(-200 + mouseY, 0, 400), constrain(-1000 + 2*mouseX, -800, 800), width/2, height/2, 0, 0, 1, 0);
  drawBattleField();
  drawSoldiers();
  drawGuns();
  drawInvalidPositionText();
}

void drawBattleField() {
  pushMatrix();
  fill(150, 75, 0);
  translate(width/2, height/2, 0);
  box(400, 30, 825);
  popMatrix();
}

void drawSoldiers() {
  // Soldados Jogador 1

  // Soldado 1
  // Cabeça
  pushMatrix();
  fill(29, 76, 184);
  translate(posXCabecaSoldado1Jog1, posYCabecaSoldado1Jog1, -290 + 15*distSoldado1Jog1);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(29, 76, 184);
  translate(width/2 + 100, posYCorpoSoldado1Jog1, -290 + 15*distSoldado1Jog1);
  rotateZ(rotateSoldado1Jog1);
  box(20, 50, 20);
  popMatrix();

  // Soldado 2
  // Cabeça
  pushMatrix();
  fill(29, 76, 184);
  translate(posXCabecaSoldado2Jog1, posYCabecaSoldado2Jog1, -290 + 15*distSoldado2Jog1);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(29, 76, 184);
  translate(width/2, posYCorpoSoldado2Jog1, -290 + 15*distSoldado2Jog1);
  rotateZ(rotateSoldado2Jog1);
  box(20, 50, 20);
  popMatrix();

  // Soldado 3
  // Cabeça
  pushMatrix();
  fill(29, 76, 184);
  translate(posXCabecaSoldado3Jog1, posYCabecaSoldado3Jog1, -290 + 15*distSoldado3Jog1);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(29, 76, 184);
  translate(width/2 - 100, posYCorpoSoldado3Jog1, -290 + 15*distSoldado3Jog1);
  rotateZ(rotateSoldado3Jog1);
  box(20, 50, 20);
  popMatrix();

  // Soldados Jogador 2

  // Soldado 1
  // Cabeça
  pushMatrix();
  fill(254, 32, 32);
  translate(posXCabecaSoldado1Jog2, posYCabecaSoldado1Jog2, 290 - 15*distSoldado1Jog2);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(254, 32, 32);
  translate(width/2 + 100, posYCorpoSoldado1Jog2, 290 - 15*distSoldado1Jog2);
  rotateZ(rotateSoldado1Jog2);
  box(20, 50, 20);
  popMatrix();

  // Soldado 2
  // Cabeça
  pushMatrix();
  fill(254, 32, 32);
  translate(posXCabecaSoldado2Jog2, posYCabecaSoldado2Jog2, 290 - 15*distSoldado2Jog2);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(254, 32, 32);
  translate(width/2, posYCorpoSoldado2Jog2, 290 - 15*distSoldado2Jog2);
  rotateZ(rotateSoldado2Jog2);
  box(20, 50, 20);
  popMatrix();

  // Soldado 3
  // Cabeça
  pushMatrix();
  fill(254, 32, 32);
  translate(posXCabecaSoldado3Jog2, posYCabecaSoldado3Jog2, 290 - 15*distSoldado3Jog2);
  sphere(20);
  popMatrix();
  
  // Corpo
  pushMatrix();
  fill(254, 32, 32);
  translate(width/2 - 100, posYCorpoSoldado3Jog2, 290 - 15*distSoldado3Jog2);
  rotateZ(rotateSoldado3Jog2);
  box(20, 50, 20);
  popMatrix();
}

void drawGuns() {
  // Arma do Jogador 1
  pushMatrix();
  fill(255, 95, 31);
  translate(width/2 - 25, height/2 + 15, -472);
  rotateY(rotateYArmaJog1);
  rotateZ(rotatezArmaJog1);
  beginShape(QUADS);
  // Base inferior
  vertex(0, 0, 0);
  vertex(50, 0, 0);
  vertex(50, 0, 50);
  vertex(0, 0, 50);

  // Base
  vertex(0, 0, 0);
  vertex(0, -150, 0);
  vertex(0, -150, 50);
  vertex(0, 0, 50);

  vertex(0, 0, 0);
  vertex(0, -150, 0);
  vertex(50, -150, 0);
  vertex(50, 0, 0);

  vertex(50, 0, 0);
  vertex(50, -150, 0);
  vertex(50, -150, 50);
  vertex(50, 0, 50);

  vertex(0, 0, 50);
  vertex(0, -150, 50);
  vertex(50, -150, 50);
  vertex(50, 0, 50);
  // Cano + Parte Superior
  vertex(0, -150, 50);
  vertex(0, -150, 150);
  vertex(50, -150, 150);
  vertex(50, -150, 50);

  vertex(0, -150, 0);
  vertex(0, -150, 150);
  vertex(0, -200, 150);
  vertex(0, -200, 0);

  vertex(0, -150, 150);
  vertex(0, -200, 150);
  vertex(50, -200, 150);
  vertex(50, -150, 150);

  vertex(50, -150, 0);
  vertex(50, -150, 150);
  vertex(50, -200, 150);
  vertex(50, -200, 0);

  vertex(0, -150, 0);
  vertex(0, -200, 0);
  vertex(50, -200, 0);
  vertex(50, -150, 0);

  vertex(0, -200, 0);
  vertex(0, -200, 150);
  vertex(50, -200, 150);
  vertex(50, -200, 0);
  endShape();
  popMatrix();

  // Parte superior
  // pushMatrix();
  // fill(255, 95, 31);
  // translate(width/2, height/2 - 160, -423);
  // rotateY(rotateYArmaJog1);
  // rotateZ(rotatezArmaJog1);
  // box(50, 50, 150);
  // popMatrix();

  // Arma do Jogador 2
  // Cabo
  pushMatrix();
  fill(255, 95, 31);
  translate(width/2 - 25, height/2 + 15, 472);
  rotateY(rotateYArmaJog2);
  rotateZ(rotatezArmaJog2);
  beginShape(QUADS);
  // Base inferior
  vertex(0, 0, 0);
  vertex(50, 0, 0);
  vertex(50, 0, -50);
  vertex(0, 0, -50);

  // Base
  vertex(0, 0, 0);
  vertex(0, -150, 0);
  vertex(0, -150, -50);
  vertex(0, 0, -50);

  vertex(0, 0, 0);
  vertex(0, -150, 0);
  vertex(50, -150, 0);
  vertex(50, 0, 0);

  vertex(50, 0, 0);
  vertex(50, -150, 0);
  vertex(50, -150, -50);
  vertex(50, 0, -50);

  vertex(0, 0, -50);
  vertex(0, -150, -50);
  vertex(50, -150, -50);
  vertex(50, 0, -50);
  // Cano + Parte Superior
  vertex(0, -150, -50);
  vertex(0, -150, -150);
  vertex(50, -150, -150);
  vertex(50, -150, -50);

  vertex(0, -150, 0);
  vertex(0, -150, -150);
  vertex(0, -200, -150);
  vertex(0, -200, 0);

  vertex(0, -150, -150);
  vertex(0, -200, -150);
  vertex(50, -200, -150);
  vertex(50, -150, -150);

  vertex(50, -150, 0);
  vertex(50, -150, -150);
  vertex(50, -200, -150);
  vertex(50, -200, 0);

  vertex(0, -150, 0);
  vertex(0, -200, 0);
  vertex(50, -200, 0);
  vertex(50, -150, 0);

  vertex(0, -200, 0);
  vertex(0, -200, -150);
  vertex(50, -200, -150);
  vertex(50, -200, 0);
  endShape();
  popMatrix();
}

void drawInvalidPositionText() {
  if(showInvalidPositionText) {
    fill(0);
    text("Posicionamento inválido. Tente novamente", 480, 100);
  }
}

void keyPressed() {
  println("mouseY: "+mouseY);
  // transmite key para circuito
  if(key == 'w') {
    // muda angulo rotate arma cima
  }

  if(key == 's') {
    // muda angulo rotate arma baixo
  }

  if(key == 'a') {
    // muda angulo rotate arma esquerda
  }

  if(key == 'd') {
    // muda angulo rotate arma direita
  }

  if(preparacao && key == ' ') {
    vezJogadorUm = !vezJogadorUm;
  }
}
