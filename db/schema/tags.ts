import { pgTable, uuid, text, timestamp } from 'drizzle-orm/pg-core';

export const tags = pgTable('tags', {
    id: uuid('id').primaryKey().defaultRandom(),
    slug: text('slug').notNull().unique(),
    label: text('label').notNull(),
    description: text('description'),
    createdAt: timestamp('created_at').defaultNow().notNull(),
});