export class SystemIds {
    constructor(el, system_ids) {
        this.el = el
        this.system_ids = system_ids
    }

    render() {
        this.el.innerHTML = this.system_ids.list().map( ([system_id, selected]) => system_id ).join(", ")
    }
}
