import { pgTable, uuid, text, timestamp, pgEnum } from 'drizzle-orm/pg-core';
import { sources } from './sources';

export const indicatorCategoryEnum = pgEnum('indicator_category', [
    'monetary',
    'fiscal',
    'trade',
    'social',
    'agricultural',
    'energy',
    'debt',
]);

export const indicators = pgTable('indicators', {
    id: uuid('id').primaryKey().defaultRandom(),
    slug: text('slug').notNull().unique(),
    name: text('name').notNull(),
    category: indicatorCategoryEnum('category').notNull(),
    unit: text('unit').notNull(),
    description: text('description'),
    source_id: uuid('source_id').references(() => sources.id),
    createdAt: timestamp('created_at').defaultNow().notNull(),
    updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

export const indicatorTags = pgTable('indicator_tags', {
    indicator_id: uuid('indicator_id').notNull().references(() => indicators.id),
    tag_id: uuid('tag_id').notNull().references(() => indicators.id),
});