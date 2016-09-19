export class SystemIds {
    constructor(system_ids) {
        this.system_ids = system_ids.sort()
        this.selected = null
    }

    select(system_id) {
        this.selected = system_id
    }

    update(system_ids) {
        this.system_ids = system_ids
    }

    list() {
        return this.system_ids.map(system_id => [system_id, system_id == this.selected])
    }
}
