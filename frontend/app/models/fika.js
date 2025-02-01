import Model, { attr, belongsTo } from '@ember-data/model';

export default class FikaModel extends Model {
  @attr('string') status;
  @attr('date') scheduledAt;
  @belongsTo('user') sender;
  @belongsTo('user') receiver;
}
