import { IAppConfig } from '../interfaces'

const ConfigDefaults: IAppConfig = {
  apiPrefix: '/api/v1',
  name: 'Koa API Template',
  port: 8080,
  version: '1.0.0'
}

export function getAppConfig(): IAppConfig {
  return {
    apiPrefix: process.env.API_PREFIX || ConfigDefaults.apiPrefix,
    name: process.env.APP_NAME || ConfigDefaults.name,
    version: process.env.APP_VERSION || ConfigDefaults.version,
    port: parseInt(process.env.APP_PORT || ConfigDefaults.port.toString())
  }
}
