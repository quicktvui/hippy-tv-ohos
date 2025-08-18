import { HippyEngineContext, HippyAny, HippyModulePromise, HippyNativeModule } from 'hippy';

import { BaseModule } from './BaseModule';
import { relationalStore } from '@kit.ArkData';
import QTAppManager from '../quick/QTAppManager';
import { BusinessError } from '@kit.BasicServicesKit';

@HippyNativeModule({ name: "ESDatabaseModule" })
export class ESDatabaseModule extends BaseModule {
  public static readonly NAME: string = 'ESDatabaseModule'
  //
  private databaseMap = new Map<string, relationalStore.RdbStore>()

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      //-------------------------------------------------------------------------------------------
      case 'getRdbStore': {
        try {
          const packageName = QTAppManager.getInstance().getPackageName()
          const databaseName = packageName + '.db'
          if (this.databaseMap.has(packageName)) {
            const store = this.databaseMap.get(packageName)
            if (store) {
              promise.resolve(store.version)
              return
            }
          }
          const config: relationalStore.StoreConfig = {
            name: databaseName,
            securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
            // encrypt: false, // 可选参数，指定数据库是否加密，默认不加密
            // customDir: 'customDir/subCustomDir', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
            // isReadOnly: false // 可选参数，指定数据库是否以只读方式打开。该参数默认为false，表示数据库可读可写。该参数为true时，只允许从数据库读取数据，不允许对数据库进行写操作，否则会返回错误码801。
          };
          relationalStore.getRdbStore(this.ctx.getAbilityContext(), config, (err, store) => {
            if (err) {
              promise?.reject(JSON.stringify(err))
              return;
            }
            this.databaseMap.set(packageName, store)
            promise.resolve(store.version)
          });
        } catch (e) {
          promise?.reject(JSON.stringify(e))
        }
        break;
      }
      //-------------------------------------------------------------------------------------------
      case 'deleteRdbStore': {
        try {
          const packageName = QTAppManager.getInstance().getPackageName()
          const databaseName = packageName + '.db'
          relationalStore.deleteRdbStore(this.ctx.getAbilityContext(), databaseName,
            (err: BusinessError) => {
              if (err) {
                promise?.reject(JSON.stringify(err))
                return;
              }
              promise.resolve(true)
            });
        } catch (e) {
          promise?.reject(JSON.stringify(e))
        }
        break;
      }
      //-------------------------------------------------------------------------------------------
      case 'execute': {
        try {
          const packageName = QTAppManager.getInstance().getPackageName()
          const sql = params[0] as string
          const version = params[1] as number
          const database = this.getDatabase(packageName)
          if (database) {
            database?.executeSql(sql).then(() => {
              if (version != undefined && version != null) {
                database.version = version
              }
            })
            promise.resolve(true)
          } else {
            promise.resolve(false)
          }
        } catch (e) {
          promise?.reject(JSON.stringify(e))
        }
        break;
      }
      //-------------------------------------------------------------------------------------------
      case 'query': {
        try {
          const packageName = QTAppManager.getInstance().getPackageName()
          const sql = params[0] as string;
          const database = this.getDatabase(packageName);
          if (!database) {
            promise.resolve(false);
            return;
          }
          database.querySql(sql).then((resultSet: relationalStore.ResultSet) => {
            const results: HippyAny[] = [];

            while (resultSet.goToNextRow()) {
              const columnCount = resultSet.columnCount;
              const row: Record<string, HippyAny> = {};

              for (let index = 0; index < columnCount; index++) {
                try {
                  const columnName = resultSet.getColumnName(index);
                  let value: relationalStore.ValueType = resultSet.getValue(index);
                  if (value instanceof Uint8Array) {
                    const v = Array.from(value) as number[];
                    row[columnName] = v;
                    break
                  }
                  if (
                    typeof value === 'number' ||
                      typeof value === 'string' ||
                      typeof value === 'boolean' ||
                    Array.isArray(value) ||
                      (value && typeof value === 'object')
                  ) {
                    row[columnName] = value as HippyAny;
                  } else {
                    row[columnName] = null;
                  }
                } catch (e) {
                }
              }
              results.push(row as HippyAny);
            }
            promise.resolve(results as HippyAny);
          }).catch((err: BusinessError) => {
            promise.reject(JSON.stringify(err));
          });
        } catch (e) {
          promise.reject(JSON.stringify(e));
        }
        break;
      }
      //-------------------------------------------------------------------------------------------
      default:
        super.call(method, params, promise);
    }
    return null;
  }

  /**
   *
   */
  private getDatabase(name: string): relationalStore.RdbStore | null | undefined {
    return this.databaseMap.get(name)
  }
}
