import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils,
  HippyMap,
  HippyValue
} from 'hippy';

import { BaseModule } from './BaseModule';
import { fileIo as fs, ReadOptions } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { buffer } from '@kit.ArkTS';

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
      case 'open':
      case 'newFile': {
        const map = params[0] as HippyMap
        const pathname = map.get('pathname') as string
        fs.open(pathname, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
          .then((file) => {
            promise.resolve(file.fd)
          }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule newFile error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
      case 'newESFile': {
        const map = params[0] as HippyMap
        const pathname = map.get('pathname') as string
        fs.open(pathname, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)
          .then((file) => {
            promise.resolve(file.fd)
          }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule newFile error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
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
        const dest = params[0] as string
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

      case 'close': {
        const fd = params[0] as number
        fs.close(fd).then(() => {
          if (promise) {
            promise.resolve(true)
          }
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule close error message:${error.message}`);
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
      case 'stat': {
        const pathname = params[0] as string
        fs.stat(pathname).then((stat: fs.Stat) => {
          promise.resolve(JSON.stringify(stat) as HippyValue)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule stat error message:${error.message}`);
          if (promise) {
            promise.reject(JSON.stringify(error))
          }
        });
        break;
      }
      case 'unlink': {
        const pathname = params[0] as string
        fs.unlink(pathname).then(() => {
          promise.resolve(true)
        }).catch((error: BusinessError) => {
          LogUtils.e(this.TAG, `ESFileModule unlink error message:${error.message}`);
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
