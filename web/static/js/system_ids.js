import React from "react"
import socket from "./socket"

export class SystemIds extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            channel: socket.channel("smppConnections:list", {}),
            systemIds: [],
            selected: null
        };
    }

    componentDidMount() {
        this.state.channel.join()
            .receive("ok", resp => {
                this.setState({systemIds: resp.systemIds});
            })
            .receive("error", resp => { console.log("Unable to join", resp) });

        this.state.channel.on("systemIdsUpdated", payload => {
            this.setState({systemIds: payload.systemIds})
        });
    }

    componentWillUnmount() {
        this.state.channel.leave();
    }

    handleClick(systemId) {
        this.props.systemIdSelected(systemId);
        this.setState({selected: systemId});
    }

    render() {
        return (
            <ul className="nav nav-pills">
            {
                this.state.systemIds.map((systemId) => {
                    let boundClick = this.handleClick.bind(this, systemId);
                    let selected = systemId == this.state.selected
                    return (
                        <li key={systemId} className={selected ? "active" : ""}>
                            <a onClick={boundClick}>{systemId}</a>
                        </li>
                    );
                })
            }
            </ul>
        );
    }
}

SystemIds.propTypes = { systemIdSelected: React.PropTypes.func.isRequired };
