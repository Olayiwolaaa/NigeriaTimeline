import { pgTable, uuid, text, integer, timestamp, pgEnum } from 'drizzle-orm/pg-core';
import { events } from './events';
import { indicators } from './indicators';
import { sources } from './sources';

export const effectTypeEnum = pgEnum('effect_type', [
    'event_to_event',
    'event_to_indicator',
]);

export const eventEffects = pgTable('event_effects', {
    id: uuid('id').primaryKey().defaultRandom(),
    type: effectTypeEnum('type').notNull(),
    cause_event_id: uuid('cause_event_id').notNull().references(() => events.id),
    effect_event_id: uuid('effect_event_id').references(() => events.id),
    effect_indicator_id: uuid('effect_indicator_id').references(() => indicators.id),
    mechanism: text('mechanism').notNull(),
    ripple_severity: integer('ripple_severity').notNull(),
    source_id: uuid('source_id').references(() => sources.id),
    createdAt: timestamp('created_at').defaultNow().notNull(),
});