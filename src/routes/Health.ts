import { Successful } from '@4lch4/koa-oto'
import { BaseEndpoint } from '../lib'

export class Health extends BaseEndpoint {
  build() {
    this.router.get('/health/liveness', ctx => Successful.ok(ctx))
    this.router.get('/health/readiness', ctx => Successful.ok(ctx))

    return this.router
  }
}
