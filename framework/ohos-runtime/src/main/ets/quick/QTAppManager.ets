/**
 * TODO
 */
export default class QTAppManager {
  private static instance: QTAppManager;

  private constructor() {
  }

  static getInstance(): QTAppManager {
    if (!QTAppManager.instance) {
      QTAppManager.instance = new QTAppManager();
    }
    return QTAppManager.instance;
  }

  public getAppId(): string {
    return "AppId"
  }

  public getPackageName(): string {
    return "test"
  }

  public getVersionCode(): number {
    return 100
  }

  public getVersionName(): string {
    return "test"
  }
}
