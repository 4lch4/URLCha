import { getAppConfig, Server } from './lib'

try {
  const AppConfig = getAppConfig()

  if (AppConfig) {
    const server = new Server(AppConfig)

    server.addRoutes().addMiddleware().start()
  } else console.error('AppConfig is empty')
} catch (err) {
  console.error(err)
  process.exit(1)
}
