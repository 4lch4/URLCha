import Router from '@koa/router'
import { Health } from './Health'

const Endpoints = [Health]

export function getRoutes(): Router[] {
  const routes: Router[] = []

  for (const Endpoint of Endpoints) routes.push(new Endpoint().build())

  return routes
}
