// bibliotecas
import processing.serial.*;      // importa biblioteca de comunicacao serial
import java.awt.event.KeyEvent;

// interface serial
Serial myPort; // definicao do objeto serial

//  ======= CONFIGURACAO SERIAL ==================

    String   porta= "COM3";  // <== acertar valor ***
    int   baudrate= 115200;  // 115200 bauds
    char    parity= 'O';     // E=even/par, O=odd/impar
    int   databits= 7;       // 7 bits de dados
    float stopbits= 2.0;     // 2 stop bits

// Variaveis de controle e configuracao
PFont font;
boolean preparacao = true;
boolean vezJogadorUm = true;
boolean showText = false;
String textToShow = "Posicionamento invalido";
int placarJogador1 = 0;
int placarJogador2 = 0;

// Variaveis de distancia e angulo dos soldados
int posXCabecaSoldado1Jog1 = 888;  // width/2 + 188
int posXCabecaSoldado2Jog1 = 700; // width/2
int posXCabecaSoldado3Jog1 = 512; // width/2 - 188
int posXCabecaSoldado1Jog2 = 888; // width/2 + 188
int posXCabecaSoldado2Jog2 = 700; // width/2
int posXCabecaSoldado3Jog2 = 512; // width/2 - 188
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
boolean soldado1Jog1Derrubado = false;
boolean soldado2Jog1Derrubado = false;
boolean soldado3Jog1Derrubado = false;
boolean soldado1Jog2Derrubado = false;
boolean soldado2Jog2Derrubado = false;
boolean soldado3Jog2Derrubado = false;
float rotateSoldado1Jog1 = 0;
float rotateSoldado2Jog1 = 0;
float rotateSoldado3Jog1 = 0;
float rotateSoldado1Jog2 = 0;
float rotateSoldado2Jog2 = 0;
float rotateSoldado3Jog2 = 0;

// Variaveis de angulo das armas
float rotateYArmaJog1 = radians(20);
float rotateXArmaJog1 = radians(-30);
float rotateYArmaJog2 = radians(20);
float rotateXArmaJog2 = 0;
int controleYArmaJog1 = 0;
int controleXArmaJog1 = 7;
int controleYArmaJog2 = 0;
int controleXArmaJog2 = 0;

void setup() {
  size(1400, 900, P3D);
  font = createFont("Calibri", 24);
  textFont(font);

  myPort = new Serial(this, porta, baudrate, parity, databits, stopbits);  // inicia comunicacao serial 
  // leitura de dados da porta serial até o caractere '#' (para leitura de "angulo,distancia#"
  myPort.bufferUntil('#'); 
}

void draw() {
  background(204); 
  camera(constrain(1.55*abs(mouseX - 500), 0, 750), constrain(-250 + mouseY, -250, 450), constrain(-1000 + 2*mouseX, -1200, 1200), width/2, height/2, 0, 0, 1, 0);
  drawScore();
  drawBattleField();
  drawSoldiers();
  drawGuns();
  drawText();
}

void drawScore() {
  pushMatrix();
  fill(0);
  translate(width/2, 0, -50);
  box(150);
  popMatrix();

  // Placar Jogador 1
  pushMatrix();
  fill(29, 76, 184);
  translate(width/2 + 15, 10, -127);
  rotateY(PI);
  textSize(48);
  text(placarJogador1, 0, 0, 0);
  popMatrix();

  // Placar Jogador 2
  pushMatrix();
  fill(254, 32, 32);
  translate(width/2 - 10, 10, 30);
  textSize(48);
  text(placarJogador2, 0, 0, 0);
  popMatrix();
}

void drawBattleField() {
  pushMatrix();
  fill(150, 75, 0);
  translate(width/2, height/2, 0);
  box(500, 30, 825);
  popMatrix();
}

void drawSoldiers() {
  if (!preparacao) {  
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
    translate(width/2 + 188, posYCorpoSoldado1Jog1, -290 + 15*distSoldado1Jog1);
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
    translate(width/2 - 188, posYCorpoSoldado3Jog1, -290 + 15*distSoldado3Jog1);
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
    translate(width/2 + 188, posYCorpoSoldado1Jog2, 290 - 15*distSoldado1Jog2);
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
    translate(width/2 - 188, posYCorpoSoldado3Jog2, 290 - 15*distSoldado3Jog2);
    rotateZ(rotateSoldado3Jog2);
    box(20, 50, 20);
    popMatrix();
  }
}

void drawGuns() {
  // Arma do Jogador 1
  pushMatrix();
  fill(255, 95, 31);
  translate(width/2 - 25, height/2 - 135, -675);
  rotateY(rotateYArmaJog1);
  rotateX(rotateXArmaJog1);
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

  // Arma do Jogador 2
  // Cabo
  pushMatrix();
  fill(255, 95, 31);
  translate(width/2 - 25, height/2 - 135, 675);
  rotateY(rotateYArmaJog2);
  rotateX(rotateXArmaJog2);
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

void drawText() {
  if(showText) {
    fill(0);
    text(textToShow, 500, 200, 380);
    pushMatrix();
    translate(950, 200, -400);
    rotateY(PI);
    text(textToShow, 0, 0, 0);
    popMatrix();

    pushMatrix();
    translate(500, 200, -250);
    rotateY(-HALF_PI);
    text(textToShow, 0, 0, 0);
    popMatrix();
  }
}

void serialEvent (Serial myPort) { 
  // inicia leitura da porta serial
  try {
      // leitura de dados da porta serial ate o caractere '#' na variavel data
      String data = myPort.readStringUntil('#');
      
      // Checa se ocorreu fim por timeout
      if(data.length() == 4) {
        if(vezJogadorUm) {
          textToShow = "Timeout! Jogador 2 ganhou!";
        } else {
          textToShow = "Timeout! Jogador 1 ganhou!";
        }
        showText = true;
        return;
      }
      // remove caractere final '#'
      data = data.substring(0,data.length()-1);
      println(data);
      // pega distancias
      int tempDistSoldado1Jog1 = int(data.substring(0, 3));
      int tempDistSoldado2Jog1 = int(data.substring(4, 7)); 
      int tempDistSoldado3Jog1 = int(data.substring(8, 11)); 
      int tempDistSoldado1Jog2 = int(data.substring(12, 15)); 
      int tempDistSoldado2Jog2 = int(data.substring(16, 19)); 
      int tempDistSoldado3Jog2 = int(data.substring(20, 23));
      println("tempDistSoldado1Jog1: "+tempDistSoldado1Jog1);
      println("tempDistSoldado2Jog1: "+tempDistSoldado2Jog1); 
      println("tempDistSoldado3Jog1: "+tempDistSoldado3Jog1);
      println("tempDistSoldado1Jog2: "+tempDistSoldado1Jog2); 
      println("tempDistSoldado2Jog2: "+tempDistSoldado2Jog2);
      println("tempDistSoldado3Jog2: "+tempDistSoldado3Jog2);  

      if(preparacao) {
        if(
          tempDistSoldado1Jog1 < 15 && 
          tempDistSoldado2Jog1 < 15 &&
          tempDistSoldado3Jog1 < 15 &&
          tempDistSoldado1Jog2 < 15 &&
          tempDistSoldado2Jog2 < 15 &&
          tempDistSoldado3Jog2 < 15
        ) {
          distSoldado1Jog1 = tempDistSoldado1Jog1;
          distSoldado2Jog1 = tempDistSoldado2Jog1;
          distSoldado3Jog1 = tempDistSoldado3Jog1;
          distSoldado1Jog2 = tempDistSoldado1Jog2;
          distSoldado2Jog2 = tempDistSoldado2Jog2;
          distSoldado3Jog2 = tempDistSoldado3Jog2;
          preparacao = false;
          showText = false;
          textToShow = "";
        } else {
          textToShow = "Posicionamento invalido";
          showText = true;
        }
      } else {
        if(!soldado1Jog1Derrubado && tempDistSoldado1Jog1 > 15) {
          placarJogador2 ++;
          soldado1Jog1Derrubado = true;
          posYCorpoSoldado1Jog1 += 10;
          posXCabecaSoldado1Jog1 -= 35;
          posYCabecaSoldado1Jog1 += 45;
          rotateSoldado1Jog1 = HALF_PI + (QUARTER_PI/4);
          if(placarJogador2 == 3) {
            textToShow = "Jogador 2 ganhou!";
            showText = true;
          }
        }

        if(!soldado2Jog1Derrubado && tempDistSoldado2Jog1 > 15) {
          placarJogador2 ++;
          soldado2Jog1Derrubado = true;
          posYCorpoSoldado2Jog1 += 10;
          posXCabecaSoldado2Jog1 -= 35;
          posYCabecaSoldado2Jog1 += 45;
          rotateSoldado2Jog1 = HALF_PI + (QUARTER_PI/4);
          if(placarJogador2 == 3) {
            textToShow = "Jogador 2 ganhou!";
            showText = true;
          }
        }

        if(!soldado3Jog1Derrubado && tempDistSoldado3Jog1 > 15) {
          placarJogador2 ++;
          soldado3Jog1Derrubado = true;
          posYCorpoSoldado3Jog1 += 10;
          posXCabecaSoldado3Jog1 -= 35;
          posYCabecaSoldado3Jog1 += 45;
          rotateSoldado3Jog1 = HALF_PI + (QUARTER_PI/4);
          if(placarJogador2 == 3) {
            textToShow = "Jogador 2 ganhou!";
            showText = true;
          }
        }

        if(!soldado1Jog2Derrubado && tempDistSoldado1Jog2 > 15) {
          placarJogador1 ++;
          soldado1Jog2Derrubado = true;
          posYCorpoSoldado1Jog2 += 10;
          posXCabecaSoldado1Jog2 -= 35;
          posYCabecaSoldado1Jog2 += 45;
          rotateSoldado1Jog2 = HALF_PI + (QUARTER_PI/4);
          if(placarJogador1 == 3) {
            textToShow = "Jogador 1 ganhou!";
            showText = true;
          }
        }

        if(!soldado2Jog2Derrubado && tempDistSoldado2Jog2 > 15) {
          placarJogador1 ++;
          soldado2Jog2Derrubado = true;
          posYCorpoSoldado2Jog2 += 10;
          posXCabecaSoldado2Jog2 -= 35;
          posYCabecaSoldado2Jog2 += 45;
          rotateSoldado2Jog2 = HALF_PI + (QUARTER_PI/4);
          if(placarJogador1 == 3) {
            textToShow = "Jogador 1 ganhou!";
            showText = true;
          }
        }

        if(!soldado3Jog2Derrubado && tempDistSoldado3Jog2 > 15) {
          placarJogador1 ++;
          soldado3Jog2Derrubado = true;
          posYCorpoSoldado3Jog2 += 10;
          posXCabecaSoldado3Jog2 -= 35;
          posYCabecaSoldado3Jog2 += 45;
          rotateSoldado3Jog2 = HALF_PI + (QUARTER_PI/4);
          if(placarJogador1 == 3) {
            textToShow = "Jogador 1 ganhou!";
            showText = true;
          }
        }
      }
  }
  catch(RuntimeException e) {
      e.printStackTrace();
  }
}

void keyPressed() {
  myPort.write(key);
  println("key: "+key);
  if(key == 'w') {
    // muda angulo rotate arma cima
    if(vezJogadorUm) {
      if(controleXArmaJog1 > 0) {
        rotateXArmaJog1 += radians(4.2);
        controleXArmaJog1 --;
      }
    } else {
      if(controleXArmaJog2 > 0) {
        rotateXArmaJog2 -= radians(4.2);
        controleXArmaJog2 --;
      }
    }
  }

  if(key == 's') {
    // muda angulo rotate arma baixo
    if(vezJogadorUm) {
      if(controleXArmaJog1 < 7) {
        rotateXArmaJog1 -= radians(4.2);
        controleXArmaJog1 ++;
      }
    } else {
      if(controleXArmaJog2 < 7) {
        rotateXArmaJog2 += radians(4.2);
        controleXArmaJog2 ++;
      }
    }
  }

  if(key == 'a') {
    // muda angulo rotate arma esquerda
    if(vezJogadorUm) {
      if(controleYArmaJog1 > 0) {
        rotateYArmaJog1 += radians(4.9);
        controleYArmaJog1 --;
      }
    } else {
      if(controleYArmaJog2 > 0) {
        rotateYArmaJog2 += radians(4.9);
        controleYArmaJog2 --;
      }
    }
  }

  if(key == 'd') {
    // muda angulo rotate arma direita
    if(vezJogadorUm) {
      if(controleYArmaJog1 < 7) {
        rotateYArmaJog1 -= radians(4.9);
        controleYArmaJog1 ++;
      }
    } else {
      if(controleYArmaJog2 < 7) {
        rotateYArmaJog2 -= radians(4.9);
        controleYArmaJog2 ++;
      }
    }
  }

  if(key == 'r') {
    reset();
  }

  if(!preparacao && key == ' ') {
    vezJogadorUm = !vezJogadorUm;
  }
}

void reset() {
  // Reseta o circuito
  preparacao = true;
  vezJogadorUm = true;
  showText = false;
  textToShow = "Posicionamento invalido";
  placarJogador1 = 0;
  placarJogador2 = 0;
  // Variaveis de distancia e angulo dos soldados
  posXCabecaSoldado1Jog1 = 888;  // width/2 + 188
  posXCabecaSoldado2Jog1 = 700; // width/2
  posXCabecaSoldado3Jog1 = 512; // width/2 - 188
  posXCabecaSoldado1Jog2 = 888; // width/2 + 188
  posXCabecaSoldado2Jog2 = 700; // width/2
  posXCabecaSoldado3Jog2 = 512; // width/2 - 188
  posYCabecaSoldado1Jog1 = 370; // height/2 - 80
  posYCabecaSoldado2Jog1 = 370; // height/2 - 80
  posYCabecaSoldado3Jog1 = 370; // height/2 - 80
  posYCabecaSoldado1Jog2 = 370; // height/2 - 80
  posYCabecaSoldado2Jog2 = 370; // height/2 - 80
  posYCabecaSoldado3Jog2 = 370; // height/2 - 80
  posYCorpoSoldado1Jog1 = 410; // height/2 - 40
  posYCorpoSoldado2Jog1 = 410; // height/2 - 40
  posYCorpoSoldado3Jog1 = 410; // height/2 - 40
  posYCorpoSoldado1Jog2 = 410; // height/2 - 40
  posYCorpoSoldado2Jog2 = 410; // height/2 - 40
  posYCorpoSoldado3Jog2 = 410; // height/2 - 40
  distSoldado1Jog1 = 0;
  distSoldado2Jog1 = 0;
  distSoldado3Jog1 = 0;
  distSoldado1Jog2 = 0;
  distSoldado2Jog2 = 0;
  distSoldado3Jog2 = 0;
  soldado1Jog1Derrubado = false;
  soldado2Jog1Derrubado = false;
  soldado3Jog1Derrubado = false;
  soldado1Jog2Derrubado = false;
  soldado2Jog2Derrubado = false;
  soldado3Jog2Derrubado = false;
  rotateSoldado1Jog1 = 0;
  rotateSoldado2Jog1 = 0;
  rotateSoldado3Jog1 = 0;
  rotateSoldado1Jog2 = 0;
  rotateSoldado2Jog2 = 0;
  rotateSoldado3Jog2 = 0;
  // Variaveis de angulo das armas
  rotateYArmaJog1 = radians(20);
  rotateXArmaJog1 = radians(-30);
  rotateYArmaJog2 = radians(20);
  rotateXArmaJog2 = 0;
  controleYArmaJog1 = 0;
  controleXArmaJog1 = 7;
  controleYArmaJog2 = 0;
  controleXArmaJog2 = 0;
}
