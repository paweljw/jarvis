import { LitElement, html } from 'https://unpkg.com/@polymer/lit-element@0.6.5/lit-element.js?module';

const styles = html`
  <style>
    :host {
      display: flex;
      flex: 1;
      flex-direction: column;
    }
    ha-card {
      flex-direction: column;
      flex: 1;
      position: relative;
      padding: 0px;
      border-radius: 4px;
      overflow: hidden;
      background: #fff;
      color: #484761;
    }

    .departure {
      display: flex;
      flex-direction: row;
      border-bottom: 1px solid #e5e4e9;
    }

    .departure:last-child {
      border-bottom: 0px;
    }

    .departure .minutes {
      padding: 10px 0;
      width: 35%;
      border-right: 1px solid #e5e4e9;
      text-align: center;
      background-color: #f5f5f8;
      font-size: 42px;
      font-weight: 700;
    }

    .departure .minutes span {
      font-size: 16px;
      text-align: left;
    }

    .departure .details {
      flex: 1;
      display: flex;
      flex-direction: column;
    }

    .departure .details-summary {
      flex: 1;
      display: flex;
      align-items: center;
      padding: 5px 0;
    }

    .departure .details-summary .details-line {
      flex: 1;
      padding-left: 20px;
    }

    .departure .details-direction {
      text-align: right;
      font-weight: 300;
      font-size: 13px;
      background-color: #f5f5f8;
      padding-top: 3px;
      padding-bottom: 3px;
      padding-right: 20px;
    }

    .details-departure {
      padding-right: 20px;
      font-weight: bold;
      text-decoration: underline;
    }
  </style>
`

class TransitCard extends LitElement {
  static get properties() {
    return {
      hass: Object,
      config: Object
    }
  }

  get entity() {
    return this.hass.states[this.config.entity]
  }

  buildDepartureItem(departure) {
    const { at, l } = departure

    let minutesLeft = null;

    if (at) {
      const [hour, minute] = at.split(':')
      const dateAt = new Date()
      dateAt.setHours(hour);
      dateAt.setMinutes(minute);

      minutesLeft = Math.round((dateAt - Date.now()) / 1000 / 60)
    }

    return html`
      <div class="departure">
        <div class="minutes">
          ${minutesLeft || '??'} <span>min</span>
        </div>
        <div class="details">
          <div class="details-summary">
            <div class="details-line">
              <ha-icon icon="mdi:train"></ha-icon>
              ${l}
            </div>

            <div class="details-departure">
              ${at}
            </div>
          </div>
        </div>
      </div>
    `
  }

  render() {
    if (!this.entity) {
      return null;
    }

    const { state } = this.entity

    if (!state || state.length === 0) {
      return null;
    }

    const departures = JSON.parse(state)

    return html`
      ${styles}
      <ha-card>
        <div class="departures">
          ${departures.map(departure => this.buildDepartureItem(departure))}
        </div>
      </ha-card>
    `
  }

  setConfig(config) {
    this.config = config;
  }

  getCardSize() {
    return 1;
  }
}

customElements.define('transit-card', TransitCard);
