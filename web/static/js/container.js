import React from "react"
import {SystemIds} from "./system_ids"
import {History} from "./history"

export class Container extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            selected: null
        };
    }

    systemIdSelected(systemId) {
        this.setState({selected: systemId});
    }

    render() {
        return (
            <div>
                <SystemIds systemIdSelected={this.systemIdSelected.bind(this)}/>
                <History systemId={this.state.selected}/>
            </div>
        );
    }

}
