// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	integrations: [
		starlight({
			title: 'ObservatoryGrid',
			social: [{ icon: 'github', label: 'GitHub', href: 'https://github.com/cbreeves/observatorygrid' }],
			sidebar: [
				{
					label: 'Blog',
					items: [
						// Each item here is one entry in the navigation menu.
						{ label: 'Foundation - A Static Astro Site', slug: 'guides/establishing-the-static-foundation' },
					],
				},
				{
					label: 'Contact',
					slug: 'contact',
				},
			],
		}),
	],
});
