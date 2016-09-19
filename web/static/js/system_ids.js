import React from "react"
import socket from "./socket"

export class SystemIds extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            channel: socket.channel("smpp_connections:list", {}),
            system_ids: []
        }
    }

    componentDidMount() {
        this.state.channel.join()
            .receive("ok", resp => {
                this.setState({system_ids: resp.system_ids});
            })
            .receive("error", resp => { console.log("Unable to join", resp) })

        this.state.channel.on("system_ids_updated", payload => {
            this.setState({system_ids: payload.system_ids})
        })
    }

    render() {
        return (
            <ul className="nav nav-pills">
            {
                this.state.system_ids.map((system_id) => {
                    return (
                        <li key={system_id}>
                            <a href="#">{system_id}</a>
                        </li>
                    );
                })
            }
            </ul>
        );
    }
}
