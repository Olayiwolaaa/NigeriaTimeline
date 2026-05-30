import { pgTable, uuid, text, timestamp, pgEnum } from 'drizzle-orm/pg-core';

export const credibilityTierEnum = pgEnum('credibility_tier', [
    'official',
    'academic',
    'wikipedia',
    'archival',
    'media',
]);

export const sources = pgTable('sources', {
    id: uuid('id').primaryKey().defaultRandom(),
    name: text('name').notNull(),
    url: text('url').notNull(),
    archive_url: text('archive_url'),
    publication_date: text('publication_date'),
    credibility_tier: credibilityTierEnum('credibility_tier').notNull(),
    notes: text('notes'),
    createdAt: timestamp('created_at').defaultNow().notNull(),
});