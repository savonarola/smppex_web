import moment from "moment";
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
                {this.history()}
                {this.copy()}
            </div>
        );
    }

    history() {
      if(!this.state.selected) return null;

      return (
          <div key={this.state.selected}>
              <History systemId={this.state.selected}/>
          </div>
      );

    }

    copy() {
        return (
            <footer>
                <p className="text-center text-muted">
                    <a href="https://github.com/savonarola/smppex">SMPPEX</a>
                    <span> is released under the </span>
                    <a href="https://opensource.org/licenses/MIT">MIT License</a>
                    <span> - Copyright &copy; </span>
                    {this.year()}
                </p>
            </footer>
        );
    }

    year() {
        let time = moment();
        return time.format("YYYY");
    }

}
