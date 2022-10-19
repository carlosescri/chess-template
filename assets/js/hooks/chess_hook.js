export const Chess = {
  mounted() {
    console.log("Chess mounted");
    this.setEvents();
    this.handleEvent("to", (obj) => this.to(obj));
    this.handleEvent("forceDraw", (obj) => this.forceDraw(obj));
  },

  setEvents() {
    const elements = document.querySelectorAll(".square");
    elements.forEach(element => {
      element.addEventListener('click', () => {
        let figure = "";

        // Send position in parent ID and third element of the class
        if (element.hasChildNodes()) {
          figure = element.children[0].classList[2]
        }

        this.sendPosition(element.id, figure);
      });
    });
  },

  removeSelected() {
    const elements = document.querySelectorAll(".square");
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

    this.pushEvent("from", { "position": position, "figure": figure });
  },

  to(obj) {
    this.removeSelected();
    const oldFigure = document.getElementById(obj.from);
    const newFigure = document.getElementById(obj.to);
    const figure = oldFigure.children[0].classList[2];

    // Check if has another figure
    if (!newFigure.hasChildNodes()) {
      if (figure != "knight" && this.isBetween(obj) || !obj.move) { return; }      
      this.draw(oldFigure, newFigure);
    } else {
      this.pushEvent("kill", { ...obj, "figure": figure});
    }
  },

  draw(oldFigure, newFigure) {
    newFigure.innerHTML = "";
    newFigure.append(oldFigure.children[0]);
    oldFigure.innerHTML = "";
  },

  forceDraw(obj) {
    const oldFigure = document.getElementById(obj.from);
    const newFigure = document.getElementById(obj.to);

    this.draw(oldFigure, newFigure);
  },

  isBetween(obj) {
    let ids = [];
    let ox = parseInt(obj.from.split("-")[1]);
    let oy = parseInt(obj.from.split("-")[0]);

    let nx = parseInt(obj.to.split("-")[1]);
    let ny = parseInt(obj.to.split("-")[0]);

    // Build array
    if(Math.abs(ox - nx) == 0 || Math.abs(oy - ny) == 0)
      ids = this.straight(ox, oy, nx, ny);
    else
      ids = this.diagonally(ox, oy, nx, ny);

    for (let i in ids) {
      let el = document.getElementById(ids[i])
      if (el.hasChildNodes()) { return true; }
    }

    return false;
  },

  straight(ox, oy, nx, ny) {
    let ids = [];
    
    let difX = Math.abs(nx - ox);
    let difY = Math.abs(ny - oy);

    let minX = ox;
    let minY = oy;

    // Set mins
    if (minX > nx) { minX = nx; }
    if (minY > ny) { minY = ny; }

    if (difX == 0)
      for (let y = 1; y < difY; y++) { ids.push(`${minY + y}-${nx}`) }
    else
      for (let x = 1; x < difX; x++) { ids.push(`${ny}-${minX + x}`) }

    return ids
  },  

  diagonally(ox, oy, nx, ny) {
    let ids = [];
    
    let movX = 1;
    let movY = 1;
    let minX = ox;
    let minY = oy;

    // Set mins
    if (minX > nx) { minX = nx; }
    if (minY > ny) { minY = ny; }

    // Set mov
    if (minX != ox) { movX = -1; }
    if (minY != oy) { movY = -1; }

    for (let i = 1; i < Math.abs(ny - oy); i++) {
      ids.push(`${oy + i * movY}-${ox + i * movX}`)
    }

    return ids
  }

}