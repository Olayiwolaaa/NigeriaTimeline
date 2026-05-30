CREATE TYPE "public"."credibility_tier" AS ENUM('official', 'academic', 'wikipedia', 'archival', 'media');--> statement-breakpoint
CREATE TYPE "public"."media_type" AS ENUM('image', 'document', 'video_link', 'audio_link', 'article_link');--> statement-breakpoint
CREATE TYPE "public"."government_type" AS ENUM('military', 'civilian', 'transitional');--> statement-breakpoint
CREATE TYPE "public"."indicator_category" AS ENUM('monetary', 'fiscal', 'trade', 'social', 'agricultural', 'energy', 'debt');--> statement-breakpoint
CREATE TYPE "public"."event_category" AS ENUM('monetary_policy', 'fiscal_policy', 'trade_policy', 'political', 'legislative', 'election', 'external_shock', 'social', 'agricultural_policy', 'energy_policy');--> statement-breakpoint
CREATE TYPE "public"."effect_type" AS ENUM('event_to_event', 'event_to_indicator');--> statement-breakpoint
CREATE TABLE "sources" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"url" text NOT NULL,
	"archive_url" text,
	"publication_date" text,
	"credibility_tier" "credibility_tier" NOT NULL,
	"notes" text,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "media" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"title" text NOT NULL,
	"type" "media_type" NOT NULL,
	"url" text NOT NULL,
	"thumbnail_url" text,
	"description" text,
	"date" text,
	"source_id" uuid,
	"entity_type" text NOT NULL,
	"entity_id" uuid NOT NULL,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "administrations" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"name" text NOT NULL,
	"head_of_state" text NOT NULL,
	"role" text NOT NULL,
	"government_type" "government_type" NOT NULL,
	"party" text,
	"start_date" date NOT NULL,
	"end_date" date,
	"context" text,
	"source_id" uuid,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "tags" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"slug" text NOT NULL,
	"label" text NOT NULL,
	"description" text,
	"created_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "tags_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "indicator_tags" (
	"indicator_id" uuid NOT NULL,
	"tag_id" uuid NOT NULL
);
--> statement-breakpoint
CREATE TABLE "indicators" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"slug" text NOT NULL,
	"name" text NOT NULL,
	"category" "indicator_category" NOT NULL,
	"unit" text NOT NULL,
	"description" text,
	"source_id" uuid,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "indicators_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "data_points" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"indicator_id" uuid NOT NULL,
	"administration_id" uuid,
	"date" date NOT NULL,
	"value" numeric(20, 6) NOT NULL,
	"disputed" boolean DEFAULT false NOT NULL,
	"estimated" boolean DEFAULT false NOT NULL,
	"notes" text,
	"source_id" uuid,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "event_tags" (
	"event_id" uuid NOT NULL,
	"tag_id" uuid NOT NULL
);
--> statement-breakpoint
CREATE TABLE "events" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"title" text NOT NULL,
	"description" text,
	"category" "event_category" NOT NULL,
	"date" date NOT NULL,
	"actor" text,
	"administration_id" uuid,
	"is_nexus_event" boolean DEFAULT false NOT NULL,
	"source_id" uuid,
	"created_at" timestamp DEFAULT now() NOT NULL,
	"updated_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "event_effects" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"type" "effect_type" NOT NULL,
	"cause_event_id" uuid NOT NULL,
	"effect_event_id" uuid,
	"effect_indicator_id" uuid,
	"mechanism" text NOT NULL,
	"ripple_severity" integer NOT NULL,
	"source_id" uuid,
	"created_at" timestamp DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "media" ADD CONSTRAINT "media_source_id_sources_id_fk" FOREIGN KEY ("source_id") REFERENCES "public"."sources"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "administrations" ADD CONSTRAINT "administrations_source_id_sources_id_fk" FOREIGN KEY ("source_id") REFERENCES "public"."sources"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "indicator_tags" ADD CONSTRAINT "indicator_tags_indicator_id_indicators_id_fk" FOREIGN KEY ("indicator_id") REFERENCES "public"."indicators"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "indicator_tags" ADD CONSTRAINT "indicator_tags_tag_id_indicators_id_fk" FOREIGN KEY ("tag_id") REFERENCES "public"."indicators"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "indicators" ADD CONSTRAINT "indicators_source_id_sources_id_fk" FOREIGN KEY ("source_id") REFERENCES "public"."sources"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "data_points" ADD CONSTRAINT "data_points_indicator_id_indicators_id_fk" FOREIGN KEY ("indicator_id") REFERENCES "public"."indicators"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "data_points" ADD CONSTRAINT "data_points_administration_id_administrations_id_fk" FOREIGN KEY ("administration_id") REFERENCES "public"."administrations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "data_points" ADD CONSTRAINT "data_points_source_id_sources_id_fk" FOREIGN KEY ("source_id") REFERENCES "public"."sources"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_tags" ADD CONSTRAINT "event_tags_event_id_events_id_fk" FOREIGN KEY ("event_id") REFERENCES "public"."events"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_tags" ADD CONSTRAINT "event_tags_tag_id_events_id_fk" FOREIGN KEY ("tag_id") REFERENCES "public"."events"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "events" ADD CONSTRAINT "events_administration_id_administrations_id_fk" FOREIGN KEY ("administration_id") REFERENCES "public"."administrations"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "events" ADD CONSTRAINT "events_source_id_sources_id_fk" FOREIGN KEY ("source_id") REFERENCES "public"."sources"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_effects" ADD CONSTRAINT "event_effects_cause_event_id_events_id_fk" FOREIGN KEY ("cause_event_id") REFERENCES "public"."events"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_effects" ADD CONSTRAINT "event_effects_effect_event_id_events_id_fk" FOREIGN KEY ("effect_event_id") REFERENCES "public"."events"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_effects" ADD CONSTRAINT "event_effects_effect_indicator_id_indicators_id_fk" FOREIGN KEY ("effect_indicator_id") REFERENCES "public"."indicators"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "event_effects" ADD CONSTRAINT "event_effects_source_id_sources_id_fk" FOREIGN KEY ("source_id") REFERENCES "public"."sources"("id") ON DELETE no action ON UPDATE no action;