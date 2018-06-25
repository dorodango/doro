import React, { Component } from "react";
import { find, map, merge, omit, prepend, prop, propEq, join, addIndex,
         uniq, identity, filter, pipe, isNil, isEmpty, sortBy, reduce, flatten} from "ramda";
import axios from 'axios';
import download from 'downloadjs';

import EntityForm from "../EntityForm/EntityForm";

const isBlank = (x) => !isNil(x) && !isEmpty(x)
const compact = filter(isBlank);


class Entity extends Component {

  constructor(props) {
    super(props);
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

  handleEdit = (ev) => {
    return this.props.handleEdit(this.props.entity);
  };

  handleDelete = (ev) => {
    return this.props.handleDelete(this.props.entity);
  };

  render() {
    return (
      <div className="Entity">
        <div className="Entity__actions">
          <button className="Entity__edit" onClick={this.handleEdit} >
            Edit
          </button>
          <button className="Entity__delete" onClick={this.handleDelete} >
            X
          </button>
        </div>
        <pre>
          <code>
            { `${JSON.stringify(this.props.entity, null, 2)}` }
          </code>
        </pre>
      </div>
    );
  }
}

class EntityForms extends Component {

  constructor(props) {
    super(props)
    this.state = {
      currentEntity: {},
      entities: [],
      availableBehaviors: []
    }
    axios.get('/api/game_state').then(
      (response) => {
        if (response.data.state) {
          this.setState(response.data.state);
        };
      },
      (error) => {
        console.log("ERROR", error);
      }
    );
    axios.get('/api/behaviors').then(response => {
      if (response.data.behaviors) {
        const formattedBehaviors = map((behavior) => ({ value: behavior, label: behavior}), response.data.behaviors);
        this.setState({availableBehaviors: formattedBehaviors});
      }
    });
  }

  handleEdit = (entity) => {
    this.setState({
      entity: entity
    });
  };

  handleDelete = (entity) => {
    const { entities } = this.state;
    this.setState({
      entities: filter((entry) => ( entry.id !== entity.id ), entities)
    });
  };

  handleDownload = (ev) => {
    download(JSON.stringify({ entities: this.state.entities }), "game_state.json", "application/json");
  };

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
    console.log("ADD ENTITY", entity);
    const currentState = this.state;

    const upsert = (obj, data) => {
      const mergeIfMatch = (entry) => ( (entry.id === obj.id) ? merge(entry, obj) : entry )

      return find( propEq('id', obj.id), data ) ? map(mergeIfMatch, data) : prepend(obj, data);
    }

    this.setState({
      entity: null,
      entities: upsert(entity, currentState.entities)
    });
  }

  reset = (_ev) => {
    this.setState({
      entities: []
    });
  };

  renderExistingEntities = () => {
    var mapIndexed = addIndex(map);
    return (
      mapIndexed(
        (elem, idx) => (
          <Entity
            key={idx}
            entity={elem}
            handleEdit={this.handleEdit}
            handleDelete={this.handleDelete} />
        )
      )(this.state.entities)
    );
  };

  render() {
    const { entities, availableBehaviors, entity } = this.state;
    const availableEntities =
      pipe(
        map(prop('id')),
        uniq,
        filter(identity),
        sortBy(identity)
      )(entities)
    return (
      <div className="EntityForms">
        <section className="EntityForms-current">
          <h3>Entities</h3>
          <button
            className="EntityForms__download"
            onClick={this.handleDownload}>Download</button>
          { this.renderExistingEntities() }
          { this.state.entities.count && (
              <div className="form-actions" >
                <button onClick={this.reset}>Reset</button>
              </div>
          )
          }
        </section>
        <aside className="EntityForms-addNew">
          { entity &&
            <EntityForm key="edit-form"
              add={this.addEntity}
              entity={entity}
              availableEntities={ availableEntities }
              availableBehaviors={ availableBehaviors }
            />
          }
          { !entity &&
            <EntityForm key="new-form"
              add={this.addEntity}
              availableEntities={ availableEntities }
              availableBehaviors={ availableBehaviors }
            />
          }
        </aside>
      </div>
    );
  }
};

export default EntityForms;