import { pgTable, uuid, text, timestamp, pgEnum } from 'drizzle-orm/pg-core';
import { sources } from './sources';

export const mediaTypeEnum = pgEnum('media_type', [
    'image',
    'document',
    'video_link',
    'audio_link',
    'article_link',
]);

export const media = pgTable('media', {
    id: uuid('id').primaryKey().defaultRandom(),
    title: text('title').notNull(),
    type: mediaTypeEnum('type').notNull(),
    url: text('url').notNull(),
    thumbnail_url: text('thumbnail_url'),
    description: text('description'),
    date: text('date'),
    source_id: uuid('source_id').references(() => sources.id),
    entity_type: text('entity_type').notNull(),
    entity_id: uuid('entity_id').notNull(),
    createdAt: timestamp('created_at').defaultNow().notNull(),
});