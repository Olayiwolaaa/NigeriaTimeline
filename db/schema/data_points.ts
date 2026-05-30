import { pgTable, uuid, numeric, date, boolean, text, timestamp } from 'drizzle-orm/pg-core';
import { indicators } from './indicators';
import { administrations } from './administrations';
import { sources } from './sources';

export const dataPoints = pgTable('data_points', {
  id: uuid('id').primaryKey().defaultRandom(),
  indicator_id: uuid('indicator_id').notNull().references(() => indicators.id),
  administration_id: uuid('administration_id').references(() => administrations.id),
  date: date('date').notNull(),
  value: numeric('value', { precision: 20, scale: 6 }).notNull(),
  disputed: boolean('disputed').default(false).notNull(),
  estimated: boolean('estimated').default(false).notNull(),
  notes: text('notes'),
  source_id: uuid('source_id').references(() => sources.id),
  createdAt: timestamp('created_at').defaultNow().notNull(),
});