import moment from "moment";
import socket from "./socket"
import React from "react"

export class History extends React.Component {
    constructor(props) {
        super(props);
        let subtopic = this.props.systemId ? this.props.systemId : "";
        this.channel = socket.channel("smppConnectionHistory:" + subtopic, {});
        this.state = {
            history: []
        };
    }

    componentDidMount() {
        this.channel.join()
            .receive("ok", resp => {
                this.setState({history: resp.history});
            })
            .receive("error", resp => { console.log("Unable to join", resp) });

        this.channel.on("newPdu", payload => {
            let history = this.state.history;
            history.unshift(payload.pduInfo);
            this.setState({history: history});
        });
    }

    componentWillUnmount() {
        this.channel.leave();
    }

    formatTimestamp(timestamp) {
        let time = moment(timestamp);
        return time.format("YYYY:MM:DD HH:mm:ss.SSS Z");
    }

    pduRow(pduInfo) {
        return (
            <tr key={pduInfo.id}>
                <td><span className={pduInfo.direction == "in" ? "label label-success" : "label label-primary" }>{pduInfo.direction}</span></td>
                <td>{this.formatTimestamp(pduInfo.time)}</td>
                <td>{pduInfo.pdu.command_name}</td>
                <td>{this.pduFields(pduInfo.pdu)}</td>
            </tr>
        );
    }

    emptyNaive(obj) {
        return Object.keys(obj).length == 0;
    }

    pduFields(pdu) {
        return (
            <div>
            {this.pduHeader(pdu)}
            {this.fields(pdu.mandatory_fields, "Mandatory fields")}
            {this.fields(pdu.optional_fields, "Optional fields")}
            </div>
        );
    }

    pduHeader(pdu) {
        return (
            <table className="table table-condensed">
                <thead>
                    <tr><th colSpan="2">Header</th></tr>
                </thead>
                <tbody>
                    {this.fieldRow("Command ID", pdu.command_id)}
                    {this.fieldRow("Command Status", pdu.command_status)}
                    {this.fieldRow("Sequence Number", pdu.sequence_number)}
                </tbody>
            </table>
        );
    }

    fields(fields, title) {
        if(this.emptyNaive(fields)) return;

        return (
            <table className="table table-condensed">
                <thead>
                    <tr><th colSpan="2">{title}</th></tr>
                </thead>
                <tbody>
                {
                    Object.keys(fields).map((name) => {
                        return this.fieldRow(name, fields[name]);
                    })
                }
                </tbody>
            </table>
        );
    }

    fieldRow(name, value) {
        return (
            <tr key={name}>
                <td>{name}</td>
                <td>{value}</td>
            </tr>
        );
    }

    render() {
        if(!this.props.systemId) return null;

        return (
            <table className="table table-condensed">
                <thead>
                    <tr>
                        <th>Direction</th>
                        <th>Timestamp</th>
                        <th>Command Name</th>
                        <th>Fields</th>
                    </tr>
                </thead>
                <tbody>
                {this.state.history.map(this.pduRow.bind(this))}
                </tbody>
            </table>
        );
    }

}

