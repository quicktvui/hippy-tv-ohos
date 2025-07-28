import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils,
  HippyMap,
} from 'hippy';

import { BaseModule } from './BaseModule';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer } from '@kit.ArkTS';
import QTAppManager from '../quick/QTAppManager';

/**
 * 文件操作模块
 */
@HippyNativeModule({ name: "ESFileModule" })
export class ESFileModule extends BaseModule {
  public static readonly NAME: string = 'ESFileModule'
  public readonly TAG: string = 'ESFileModule'

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    switch (method) {
      //
      case 'open': {
        try {
          const map = params[0] as HippyMap
          const pathname = map.get('pathname') as string
          const rootFilePath = QTAppManager.getInstance().getESAppFilePath(this.ctx)
          const exists = fs.accessSync(rootFilePath)
          if (!exists) {
            fs.mkdirSync(rootFilePath, true)
          }
          const file =
            fs.openSync(rootFilePath + "/" + pathname, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
          if (promise) {
            promise.resolve(file.fd)
          }
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule open error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //
      case 'newESFile': {
        try {
          const map = params[0] as HippyMap
          const pathname = map.get('pathname') as string
          const rootFilePath = this.ctx.getAbilityContext().filesDir
          const file =
            fs.openSync(rootFilePath + "/" + pathname, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
          if (promise) {
            promise.resolve(file.fd)
          }
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule newFile error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //
      case 'access': {
        try {
          const map = params[0] as HippyMap
          const pathname = map.get('pathname') as string
          const rootFilePath = QTAppManager.getInstance().getESAppFilePath(this.ctx)
          const exist = fs.accessSync(rootFilePath + "/" + pathname)
          LogUtils.i(this.TAG,
            `ESFileModule op: access ${rootFilePath + "/" + pathname} ret:${exist}`);
          if (promise) {
            promise.resolve(exist)
          }
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule access error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //
      case 'close': {
        try {
          const map = params[0] as HippyMap
          const fd = map.get('id') as number
          LogUtils.i(this.TAG, `ESFileModule close fd:${fd}`);
          fs.closeSync(fd)
          if (promise) {
            promise.resolve(true)
          }
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule close error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //
      case 'stat': {
        try {
          const map = params[0] as HippyMap
          const pathname = map.get('pathname') as string
          const rootFilePath = QTAppManager.getInstance().getESAppFilePath(this.ctx)
          const stat: fs.Stat = fs.statSync(rootFilePath + "/" + pathname)
          LogUtils.i(this.TAG,
            `ESFileModule op: stat file: ${rootFilePath + "/" + pathname} ret:${stat}`);
          if (promise) {
            const info = new Map<string, HippyAny>()
            info.set("ino", stat.ino.toString())
            info.set("mode", stat.mode)
            info.set("uid", stat.uid)
            info.set("gid", stat.gid)
            info.set("size", stat.size)
            info.set("atime", stat.atime)
            info.set("mtime", stat.mtime)
            info.set("ctime", stat.ctime)
            info.set("atimeNs", stat.atimeNs?.toString())
            info.set("mtimeNs", stat.mtimeNs?.toString())
            info.set("ctimeNs", stat.ctimeNs?.toString())
            info.set("isBlockDevice", stat.isBlockDevice())
            info.set("isCharacterDevice", stat.isCharacterDevice())
            info.set("isDirectory", stat.isDirectory())
            info.set("isFIFO", stat.isFIFO())
            info.set("isSocket", stat.isSocket())
            info.set("isSymbolicLink", stat.isSymbolicLink())
            promise.resolve(info)
          }
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule stat error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //
      case 'isDirectory': {
        try {
          const map = params[0] as HippyMap
          const pathname = map.get('pathname') as string
          const rootFilePath = QTAppManager.getInstance().getESAppFilePath(this.ctx)
          const stat: fs.Stat = fs.statSync(rootFilePath + "/" + pathname)
          LogUtils.i(this.TAG, `ESFileModule op: isDirectory file: ${rootFilePath + "/" +
            pathname} ret:${stat.isDirectory()}`);
          if (promise) {
            promise.resolve(stat.isDirectory())
          }
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule stat error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //
      case 'isFile': {
        try {
          const map = params[0] as HippyMap
          const pathname = map.get('pathname') as string
          const rootFilePath = QTAppManager.getInstance().getESAppFilePath(this.ctx)
          const stat: fs.Stat = fs.statSync(rootFilePath + "/" + pathname)
          LogUtils.i(this.TAG, `ESFileModule op: isDirectory file: ${rootFilePath + "/" +
            pathname} ret:${stat.isFile()}`);
          if (promise) {
            promise.resolve(stat.isFile())
          }
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule stat error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //
      case 'unlink': {
        try {
          const map = params[0] as HippyMap
          const pathname = map.get('pathname') as string
          const rootFilePath = QTAppManager.getInstance().getESAppFilePath(this.ctx)
          LogUtils.i(this.TAG, `ESFileModule op: unlink path :${rootFilePath + "/" + pathname}`);
          fs.unlinkSync(rootFilePath + "/" + pathname)
          promise.resolve(true)
        } catch (error) {
          LogUtils.e(this.TAG, `ESFileModule unlink error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        }
        break;
      }
    //-------------------------------------------------------------------------------------------
      case 'listFile': {
        const pathname = params[0] as string
        fs.listFile(pathname).then((files: string[]) => {
          promise.resolve(files)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule listFile error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
      case 'mkdir': {
        const pathname = params[0] as string
        fs.mkdir(pathname).then(() => {
          promise.resolve(true)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule mkdir error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
      case 'moveFile': {
        const src = params[0] as string
        const dest = params[1] as string
        fs.moveFile(src, dest).then(() => {
          promise.resolve(true)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule moveFile error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
      case 'read': {
        const fd = params[0] as number
        const arrayBuffer = new ArrayBuffer(1024);
        const readOptions: ReadOptions = {
          offset: 0,
          length: arrayBuffer.byteLength
        };
        fs.read(fd, arrayBuffer, readOptions).then((readLen: number) => {
          const buf = buffer.from(arrayBuffer, 0, readLen);
          if (promise) {
            promise.resolve(buf.toString())
          }
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule read error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }


      case 'rename': {
        const oldPath = params[0] as string
        const newPath = params[1] as string
        fs.rename(oldPath, newPath).then(() => {
          promise.resolve(true)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule rename error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
      case 'rmdir': {
        const pathname = params[0] as string
        fs.rmdir(pathname).then(() => {
          promise.resolve(true)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule rmdir error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }

      case 'write': {
        const fd = params[0] as number
        const content = params[1] as string
        fs.write(fd, content).then((count: number) => {
          promise.resolve(count)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule write error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }
}
