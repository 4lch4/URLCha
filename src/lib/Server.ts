import Printer from '@4lch4/koa-router-printer'
import Koa from 'koa'
import KBody from 'koa-body'
import Helmet from 'koa-helmet'
import { IAppConfig } from '../interfaces'
import { getRoutes } from '../routes'

export class Server {
  private config: IAppConfig
  private app: Koa

  constructor(config: IAppConfig) {
    this.app = new Koa()

    this.config = config
  }

  start() {
    this.app.listen(this.config.port, () => {
      console.log(
        `${this.config.name}-v${this.config.version} has come online!`
      )
    })

    return this // For method chaining
  }

  addMiddleware() {
    this.app.use(KBody())
    this.app.use(Helmet())

    return this // For method chaining
  }

  addRoutes() {
    const routes = getRoutes()

    for (const route of routes) {
      this.app.use(route.routes())
      this.app.use(route.allowedMethods())
    }

    Printer(this.app, {
      displayHead: false,
      displayPrefix: true
    })

    return this // For method chaining
  }
}
