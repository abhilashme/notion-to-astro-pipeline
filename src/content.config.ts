import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// Blog posts live as Markdown files in src/content/blog/.
// To publish a new post: add a .md file there with the frontmatter below.
const blog = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/blog' }),
  schema: z.object({
    title: z.string(),
    description: z.string(),
    pubDate: z.coerce.date(),
    tags: z.array(z.string()).optional(),
    draft: z.boolean().optional(),
  }),
});

export const collections = { blog };
