import { pgTable, uuid, text, date, timestamp, pgEnum } from 'drizzle-orm/pg-core';
import { sources } from './sources';

export const governmentTypeEnum = pgEnum('government_type', [
  'military',
  'civilian',
  'transitional',
]);

export const administrations = pgTable('administrations', {
  id: uuid('id').primaryKey().defaultRandom(),
  name: text('name').notNull(),
  head_of_state: text('head_of_state').notNull(),
  role: text('role').notNull(),
  government_type: governmentTypeEnum('government_type').notNull(),
  party: text('party'),
  start_date: date('start_date').notNull(),
  end_date: date('end_date'),
  context: text('context'),
  source_id: uuid('source_id').references(() => sources.id),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});