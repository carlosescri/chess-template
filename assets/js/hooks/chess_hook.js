export const Chess = {
  mounted() {
    console.log("Chess mounted");
    this.init();
    this.handleEvent("to", (obj) => this.to(obj));
    this.handleEvent("forceDraw", (obj) => this.forceDraw(obj));
  },

  init() {
    let elements = document.querySelectorAll(".square");
    elements.forEach(element => {
      element.addEventListener('click', () => {
        let figure = "";

        // Send position in parent ID and third element of the class
        if(element.hasChildNodes()) {
          figure = element.children[0].classList[2]
        }

        this.sendPosition(element.id, figure);
      });
    });
  },

  removeSelected() {
    let elements = document.querySelectorAll(".square");
    elements.forEach(el => {
      el.classList.remove("selected");
    });
  },

  sendPosition(position = null, figure = null) {
    if (position && figure) {
      this.removeSelected();
      let selected = document.getElementById(position);
      selected.classList.add("selected");
    }

    this.pushEvent("from", {"position": position, "figure": figure})
  },

  to(obj) {
    let oldFigure = document.getElementById(obj.from);
    let newFigure = document.getElementById(obj.to);

    // Check if has another figure
    if(!newFigure.hasChildNodes() && obj.move) {
      this.draw(oldFigure, newFigure)     
    } else {
      this.pushEvent("kill", {...obj, "figure": oldFigure.children[0].classList[2]})
    }
  },

  draw(oldFigure, newFigure) {
    this.removeSelected();
    newFigure.append(oldFigure.children[0]);
    oldFigure.innerHTML = "";
  },

  forceDraw(obj) {
    console.log(obj);
    let oldFigure = document.getElementById(obj.from);
    let newFigure = document.getElementById(obj.to);

    console.log(oldFigure);
    console.log(newFigure);

    this.draw(oldFigure, newFigure);
  }
}