import React, { Component } from "react";
import { find, map, merge, omit, append, prop, propEq, join,
         uniq, identity, filter, pipe, isNil, isEmpty, reduce, flatten} from "ramda";

import EntityForm from "../EntityForm/EntityForm";


const isBlank = (x) => !isNil(x) && !isEmpty(x)
const compact = filter(isBlank);


class Entity extends Component {

  constructor(props) {
    super(props);
    console.log(props);
  }

  remapEntity = (entity) => {
    return {
      id: entity.id,
      name: entity.name,
      behaviors: [],
      proto: null,
      props: compact(omit(["name", "id"], entity))
    };
  };

  render() {
    return (
      <pre>
        <code>
          { `${JSON.stringify(this.props.entity, null, 2)}` }
        </code>
      </pre>
    );
  }
}

class EntityForms extends Component {

  constructor(props) {
    super(props)
    this.state = {
      entities: []
    }
  }

  remapEntity = (entity) => {
    return {
      id: entity.id,
      name: entity.name,
      behaviors: [],
      proto: null,
      props: compact(omit(["name", "id"], entity))
    };
  };

  /* currentGameState = () => {
   *   const { entities } = this.state;
   *   const formattedEntities = map( this.remapEntity, entities);
   *   return {
   *     entities: formattedEntities
   *   };
   * };
   */
  addEntity = (entity) => {
    const currentState = this.state;

    const upsert = (obj, data) => {
      const mergeIfMatch = (entry) => ( (entry.id === obj.id) ? merge(entry, obj) : entry )

      return find( propEq('id', obj.id), data ) ? map(mergeIfMatch, data) : append(obj, data);
    }

    this.setState({
      ...currentState,
      entities: upsert(entity, currentState.entities)
    });
  }

  reset = (_ev) => {
    const currentState = this.state;

    this.setState({
      ...currentState,
      entities: []
    });
  };

  renderExistingEntities = () => {
    return pipe(
      map( (elem, idx) => [
        <Entity key={idx} entity={elem}/>,
        <div key={ `separator-${idx}` }>,</div>
      ]),
      flatten
    )(this.state.entities);
  };

  render() {
    const { entities } = this.state;
    const availableEntities =
      pipe(
        map(prop('name')),
        uniq,
        filter(identity)
      )(entities)
    return (
      <div className="EntityForms">
        <section className="EntityForms-current">
          {this.renderExistingEntities()}
          { this.state.entities.count && (
            <div className="form-actions" >
              <button onClick={this.reset}>Reset</button>
            </div>
            )
          }
        </section>
        <aside className="EntityForms-addNew">
          <EntityForm
            add={this.addEntity}
            availableEntities={ availableEntities }
          />
        </aside>
      </div>
    );
  }
};

export default EntityForms;