import Alpine from "alpinejs"
import {Socket} from "phoenix"

window.Alpine = Alpine

Alpine.data("smppApp", () => ({
  socket: null,
  listChannel: null,
  historyChannel: null,
  systemIds: [],
  selectedSystemId: null,
  history: [],
  openPdus: {},

  init() {
    this.socket = new Socket("/socket", {params: {token: window.userToken}})
    this.socket.connect()

    this.listChannel = this.socket.channel("smppConnections:list", {})
    this.listChannel
      .join()
      .receive("ok", (resp) => {
        this.systemIds = resp.systemIds || []
      })
      .receive("error", (resp) => {
        console.error("Unable to join smppConnections:list", resp)
      })

    this.listChannel.on("systemIdsUpdated", (payload) => {
      this.systemIds = payload.systemIds || []

      if (this.selectedSystemId && !this.systemIds.includes(this.selectedSystemId)) {
        this.selectedSystemId = null
        this.history = []
        this.openPdus = {}

        if (this.historyChannel) {
          this.historyChannel.leave()
          this.historyChannel = null
        }
      }
    })
  },

  selectSession(systemId) {
    this.selectedSystemId = systemId
    this.history = []
    this.openPdus = {}

    if (this.historyChannel) {
      this.historyChannel.leave()
      this.historyChannel = null
    }

    this.historyChannel = this.socket.channel("smppConnectionHistory:" + systemId, {})
    this.historyChannel
      .join()
      .receive("ok", (resp) => {
        this.history = resp.history || []
      })
      .receive("error", (resp) => {
        console.error("Unable to join smppConnectionHistory:" + systemId, resp)
      })

    this.historyChannel.on("newPdu", (payload) => {
      this.history.unshift(payload.pduInfo)
    })
  },

  formatTime(timestamp) {
    const date = new Date(timestamp)
    const pad = (value, size = 2) => String(value).padStart(size, "0")
    const offset = -date.getTimezoneOffset()
    const offsetSign = offset >= 0 ? "+" : "-"
    const offsetHours = pad(Math.floor(Math.abs(offset) / 60))
    const offsetMinutes = pad(Math.abs(offset) % 60)

    return [
      `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())}`,
      `${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}.${pad(date.getMilliseconds(), 3)}`,
      `${offsetSign}${offsetHours}:${offsetMinutes}`
    ].join(" ")
  },

  isEmpty(obj) {
    return Object.keys(obj).length === 0
  },

  fieldEntries(fields) {
    return Object.entries(fields || {}).sort(([left], [right]) => left.localeCompare(right))
  },

  formatFieldName(name) {
    return String(name).replaceAll("_", " ")
  },

  formatCommandId(commandId) {
    const numericId = Number(commandId)

    if (Number.isNaN(numericId)) {
      return String(commandId)
    }

    return `${numericId} / 0x${numericId.toString(16).toUpperCase().padStart(8, "0")}`
  },

  isPduOpen(id) {
    return Boolean(this.openPdus[id])
  },

  togglePdu(id) {
    this.openPdus[id] = !this.openPdus[id]
  },

  hasValue(value) {
    return value !== null && value !== undefined
  },

  formatValue(value) {
    if (value === null || value === undefined) {
      return ""
    }

    if (typeof value === "object") {
      return JSON.stringify(value, null, 2)
    }

    return String(value)
  }
}))

Alpine.start()
