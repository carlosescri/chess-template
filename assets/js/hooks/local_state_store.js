export const Storage = {
  mounted() {
    console.log("Local state store mounted");
    this.handleEvent("store", (obj) => this.store(obj))
    this.handleEvent("clear", (obj) => this.clear(obj))
    this.handleEvent("restore", (obj) => this.restore(obj))
    this.handleEvent("redirect", (obj) => this.redirect(obj))
  },

  store(obj) {
    sessionStorage.setItem("username", obj.username)
    sessionStorage.setItem("room", obj.room)
  },

  restore(obj) {
    console.log(sessionStorage);
    let username = sessionStorage.getItem(obj.username)
    let room = sessionStorage.getItem(obj.room)
    this.pushEvent("restoreSettings", {"username": username, "room": room})
  },

  redirect(obj) {
    sessionStorage.setItem("username", obj.username)
    sessionStorage.setItem("room", obj.room)
    this.pushEvent("redirect")
  },

  clear(obj) {
    obj.clear.forEach(key => {
      sessionStorage.removeItem(key)
    });
  }
}