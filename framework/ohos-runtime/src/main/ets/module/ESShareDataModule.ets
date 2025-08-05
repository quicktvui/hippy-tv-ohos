import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils
} from 'hippy';

import { BaseModule } from './BaseModule';
import { preferences, ValueType } from '@kit.ArkData';
import QTAppManager from '../quick/QTAppManager';

export enum ESShareDataType {
  BOOLEAN = 1,
  INT = 2,
  LONG = 3,
  FLOAT = 4,
  STRING = 5,
  STRING_ARRAY = 6,
  MAP = 7
}

export enum ESShareDataMode {
  PRIVATE = 0, // 仅模块自身访问
  READABLE = 1, // 可被其他模块读取
  READ_WRITE = 2 // 可读可写
}

export interface ESShareData {
  type: ESShareDataType;
  mode: ESShareDataMode;
  secretKey?: string;
  data: HippyAny;
}

/**
 *
 */
@HippyNativeModule({ name: "ESShareDataModule" })
export class ESShareDataModule extends BaseModule {
  public static readonly NAME: string = 'ESShareDataModule'
  public readonly TAG: string = 'ESShareDataModule'
  dataPreferences: preferences.Preferences | null = null;

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  /**
   *
   */
  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      case 'get': {
        try {
          const packageName = params[0] as string
          const secretKey = params[1] as string
          const key = params[1] as string
          const defValue = params[1] as HippyAny
          const shareData =
            this.getShareData(this.getSelfPackageName(), packageName, secretKey, key, defValue)
          promise.resolve(shareData)
        } catch (error) {
          LogUtils.e(this.TAG, `get error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
      case 'put': {
        try {
          const packageName = params[0] as string
          const secretKey = params[1] as string
          const key = params[1] as string
          const value = params[1] as HippyAny
          const mode = params[1] as number
          const dataType = params[1] as number
          const ret =
            this.putShareData(this.getSelfPackageName(), packageName, secretKey, key, value,
              dataType, mode)
          promise.resolve(ret)
        } catch (error) {
          LogUtils.e(this.TAG, `get error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }


  private putShareData(selfPackageName: string, sharedPackageName: string,
    secretKey: string, key: string, value: HippyAny, shareDataType: ESShareDataType,
    shareDataMode: ESShareDataMode
  ): boolean {
    try {
      if (this.dataPreferences == null) {
        this.initShareData(sharedPackageName)
      }
      if (this.dataPreferences == null) {
        return false
      }
      const sharedDataString: preferences.ValueType = this.dataPreferences.getSync(key, null)

      //没有数据
      if (sharedDataString == null) {
        if (this.isSelfData(selfPackageName, sharedPackageName)) {
          const shareData: ESShareData = {
            type: shareDataType,
            mode: shareDataMode,
            data: value,
            secretKey: secretKey
          }
          this.dataPreferences.putSync(key, JSON.stringify(shareData))
          this.dataPreferences.flushSync()
          return true
        } else {
          LogUtils.e(this.TAG, `ohters data can not write!have no permissions`);
          return false
        }
      }
      //已有数据
      else {
        const shareData: ESShareData = JSON.parse(sharedDataString as string)
        //修改已有的自己的数据
        if (this.isSelfData(selfPackageName, sharedPackageName)) {
          shareData.type = shareDataType
          shareData.mode = shareDataMode //自己改权限
          shareData.data = value //自己改数据
          shareData.secretKey = secretKey //自己改秘钥

          this.dataPreferences.putSync(key, JSON.stringify(shareData))
          this.dataPreferences.flushSync()
          return true
        }
        //修改已有其他人的数据
        else {
          if (shareData.type >= ESShareDataMode.READ_WRITE) {
            if (shareData.secretKey != undefined
              && shareData.secretKey != null
            ) {
              //秘钥匹配
              if (shareData.secretKey == secretKey) {
                shareData.data = value
                this.dataPreferences.putSync(key, JSON.stringify(shareData))
                this.dataPreferences.flushSync()
                return true
              }
              //秘钥不匹配
              else {
                LogUtils.e(this.TAG, `ohters data can not write!have no permissions`);
                return false
              }
            }
            //没有秘钥
            else {
              shareData.data = value
              this.dataPreferences.putSync(key, JSON.stringify(shareData))
              this.dataPreferences.flushSync()
              return true
            }
          } else {
            LogUtils.e(this.TAG, `ohters data can not write!have no permissions`);
            return false
          }
        }
      }
    } catch (error) {
      LogUtils.e(this.TAG, `init error message:${error.message}`);
    }
    return false
  }

  private getShareData(selfPackageName: string, sharedPackageName: string,
    secretKey: string, key: string, defValue: HippyAny
  ): HippyAny {
    try {
      if (this.dataPreferences == null) {
        this.initShareData(sharedPackageName)
      }
      if (this.dataPreferences == null) {
        return defValue
      }
      const sharedDataString: preferences.ValueType = this.dataPreferences.getSync(key, null)
      //没有数据
      if (sharedDataString == null) {
        return defValue
      }
      //已有数据
      else {
        const shareData: ESShareData = JSON.parse(sharedDataString as string)
        //已有的自己的数据
        if (this.isSelfData(selfPackageName, sharedPackageName)) {
          return shareData.data
        }
        //已有其他人的数据
        else {
          if (shareData.type >= ESShareDataMode.READABLE) {
            if (shareData.secretKey != undefined
              && shareData.secretKey != null
            ) {
              //秘钥匹配
              if (shareData.secretKey == secretKey) {
                return shareData.data
              }
              //秘钥不匹配
              else {
                LogUtils.e(this.TAG, `ohters data can not write!have no permissions`);
                return defValue
              }
            }
            //没有秘钥
            else {
              return shareData.data
            }
          } else {
            LogUtils.e(this.TAG, `ohters data can not write!have no permissions`);
            return defValue
          }
        }
      }
    } catch (error) {
      LogUtils.e(this.TAG, `init error message:${error.message}`);
    }
    return defValue
  }

  private initShareData(sharedPackageName: string) {
    let options: preferences.Options = { name: sharedPackageName + "_share_data" };
    const pref = preferences.getPreferencesSync(this.ctx.getAbilityContext(), options);
    this.dataPreferences = pref
  }

  private isSelfData(selfPackageName: string, sharedPackageName: string): boolean {
    return selfPackageName == sharedPackageName &&
      sharedPackageName != null && sharedPackageName != undefined;
  }

  private getSelfPackageName(): string {
    return QTAppManager.getInstance().getPackageName();
  }
}
