import {pgTable, uuid, text, date, timestamp, pgEnum, boolean} from 'drizzle-orm/pg-core';
import { administrations } from './administrations';
import { sources } from './sources';

export const eventCategoryEnum = pgEnum('event_category', [
    'monetary_policy',
    'fiscal_policy',
    'trade_policy',
    'political',
    'legislative',
    'election',
    'external_shock',
    'social',
    'agricultural_policy',
    'energy_policy',
]);

export const events = pgTable('events', {
    id: uuid('id').primaryKey().defaultRandom(),
    title: text('title').notNull(),
    description: text('description'),
    category: eventCategoryEnum('category').notNull(),
    date: date('date').notNull(),
    actor: text('actor'),
    administration_id: uuid('administration_id').references(() => administrations.id),
    is_nexus_event: boolean('is_nexus_event').default(false).notNull(),
    source_id: uuid('source_id').references(() => sources.id),
    createdAt: timestamp('created_at').defaultNow().notNull(),
    updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

export const eventTags = pgTable('event_tags', {
    event_id: uuid('event_id').notNull().references(() => events.id),
    tag_id: uuid('tag_id').notNull().references(() => events.id),
});