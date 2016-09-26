import React from "react"
import socket from "./socket"

export class SystemIds extends React.Component {
    constructor(props) {
        super(props);
        this.channel = socket.channel("smppConnections:list", {});
        this.state = {
            systemIds: [],
            selected: null
        };
    }

    componentDidMount() {
        this.channel.join()
            .receive("ok", resp => {
                this.setState({systemIds: resp.systemIds});
            })
            .receive("error", resp => { console.log("Unable to join", resp) });

        this.channel.on("systemIdsUpdated", payload => {
            this.setState({systemIds: payload.systemIds})
        });
    }

    componentWillUnmount() {
        this.channel.leave();
    }

    handleClick(systemId) {
        this.props.systemIdSelected(systemId);
        this.setState({selected: systemId});
    }

    render() {
        return (
            <div>
                <p className="bg-info" id="help-banner">
                {this.helpBanner()}
                </p>
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
            </div>
        );
    }

    sessionsPresent() {
        return this.state.systemIds.length > 0;
    }

    helpBanner() {
        if(this.sessionsPresent()) {
            return (
                <span>
                    Select one of the SMPP sessions below to watch its realtime PDU log or establish a new SMPP session by connecting to <code>smppex.rubybox.ru:2775</code> and binding in any mode with any credentials
                </span>
            );
        } else {
            return (
                <span>
                    No SMPP sessions established. You may establish a new SMPP session by connecting to <code>smppex.rubybox.ru:2775</code> and binding in any mode with any credentials
                </span>
            );
        }
    }

}

SystemIds.propTypes = { systemIdSelected: React.PropTypes.func.isRequired };
