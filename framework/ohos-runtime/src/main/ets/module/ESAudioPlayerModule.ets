import {
  HippyEngineContext,
  HippyAny,
  HippyModulePromise,
  HippyNativeModule,
  LogUtils,
  HippyException
} from 'hippy';

import { BaseModule } from './BaseModule';
import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { QTPlayerEvent } from '../components/player/QTPlayerEvent';
import { QTPlayerEventProp } from '../components/player/QTPlayerEventProp';
import { QTPlayerState } from '../components/player/QTPlayerState';
import Url from '@ohos.url'

/**
 * 音频播放
 */
@HippyNativeModule({ name: "ESAudioPlayerModule" })
export class ESAudioPlayerModule extends BaseModule {
  public static readonly NAME: string = 'ESAudioPlayerModule'
  private readonly TAG: string = 'ESAudioPlayerModule'
  private mediaPlayerMap = new Map<number, media.AVPlayer>()

  constructor(ctx: HippyEngineContext) {
    super(ctx)
  }

  initialize(): void {
  }

  destroy(): void {
    this.mediaPlayerMap.clear()
  }

  public call(method: string, params: Array<HippyAny>, promise: HippyModulePromise): HippyAny {
    LogUtils.d(this.TAG, '=======call=======>>>>>method:' + method + " params:" + params);
    switch (method) {
      case 'init': {
        const playerId = this.generateId();
        this.createMediaPlayer().then((mediaPlayer) => {
          if (mediaPlayer) {
            this.mediaPlayerMap.set(playerId, mediaPlayer);
            this.initMediaPlayer(playerId, mediaPlayer)

            LogUtils.d(this.TAG, `Player ${playerId} initialized and stored.`);
            //
            const map = new Map<string, HippyAny>()
            map.set(QTPlayerEventProp.PLAYER_ID, playerId)
            map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.INITIALIZE_SUCCESS)
            this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)

            promise?.resolve(playerId);
          } else {
            LogUtils.d(this.TAG, `Failed to create player`);

            const map = new Map<string, HippyAny>()
            map.set(QTPlayerEventProp.PLAYER_ID, playerId)
            map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.INITIALIZE_ERROR)
            this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)

            promise?.reject?.(-1);
          }
        }).catch((err: BusinessError) => {
          LogUtils.d(this.TAG, 'init error.' + JSON.stringify(err));

          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, playerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.INITIALIZE_ERROR)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)

          promise?.reject(-1)
        });
        break;
      }
      case 'play': {
        const playerId = params[0] as number
        const streamingURL = params[1] as string

        const player = this.getMediaPlayer(playerId)
        if (player) {
          player.url = Url.URL.parseURL(streamingURL).toString();
          promise?.resolve?.(true);
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'resume':
      case 'start': {
        const playerId = params[0] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          player.play().then(() => {
            LogUtils.i(this.TAG, 'media resume')
            promise?.resolve?.(true);
          }).catch((err: HippyException) => {
            LogUtils.e(this.TAG, `ERROR: ${err}`)
            promise?.reject?.(JSON.stringify(err));
          });
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'pause': {
        const playerId = params[0] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          player.pause().then(() => {
            LogUtils.i(this.TAG, 'media pause')
            promise?.resolve?.(true);
          }).catch((err: HippyException) => {
            LogUtils.e(this.TAG, `ERROR: ${err}`)
            promise?.reject?.(JSON.stringify(err));
          });
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'seekTo': {
        const playerId = params[0] as number
        const newPosition = params[1] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          try {
            player.seek(newPosition, media.SeekMode.SEEK_PREV_SYNC)
            promise?.resolve?.(true);
          } catch (err) {
            LogUtils.e(this.TAG, `ERROR: ${err}`)
            promise?.reject?.(JSON.stringify(err));
          }
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'stop': {
        const playerId = params[0] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          player.stop().then(() => {
            LogUtils.i(this.TAG, 'media stopped')
            promise?.resolve?.(true);
          }).catch((err: HippyException) => {
            LogUtils.e(this.TAG, `ERROR: ${err}`)
            promise?.reject?.(JSON.stringify(err));
          });
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'setPlayRate': {
        const playerId = params[0] as number
        const speed = params[1] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          try {
            player.setSpeed(speed)
          } catch (err) {
            LogUtils.e(this.TAG, `ERROR: ${err}`)
            promise?.reject?.(JSON.stringify(err));
          }
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'release': {
        const playerId = params[0] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          player.release().then(() => {
            LogUtils.i(this.TAG, 'media release')
            promise?.resolve?.(true);
          }).catch((err: HippyException) => {
            LogUtils.e(this.TAG, `ERROR: ${err}`)
            promise?.reject?.(JSON.stringify(err));
          });
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'isPlaying': {
        break;
      }
      case 'isPaused': {
        break;
      }
      case 'getDuration': {
        const playerId = params[0] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          promise?.resolve?.(player.duration);
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'getCurrentPosition': {
        const playerId = params[0] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          promise?.resolve?.(player.currentTime);
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'getBufferPercentage': {
        promise?.resolve?.(-1);
        break;
      }
      case 'getCurrentPlayRate': {
        promise?.resolve?.(-1);
        break;
      }
      case 'setVolume': {
        const playerId = params[0] as number
        const volume = params[1] as number
        const player = this.getMediaPlayer(playerId)
        if (player) {
          player.setVolume(volume)
          promise?.resolve?.(true);
        } else {
          promise?.reject?.(false);
        }
        break;
      }
      case 'getLeftVolume': {
        promise?.resolve?.(-1);
        break;
      }
      case 'getRightVolume': {
        promise?.resolve?.(-1);
        break;
      }
      default:
        super.call(method, params, promise);
    }
    return null;
  }

  private createMediaPlayer(): Promise<media.AVPlayer | null> {
    return media.createAVPlayer().then((video) => {
      if (video != null) {
        LogUtils.i(this.TAG, 'createAVPlayer success');
        return video
      } else {
        LogUtils.e(this.TAG, 'createAVPlayer fail');
        return null
      }
    })
  }

  private getMediaPlayer(playerId: number): media.AVPlayer | undefined {
    if (this.mediaPlayerMap.has(playerId)) {
      LogUtils.d(this.TAG, `Player ${playerId} already initialized`);
      const player = this.mediaPlayerMap.get(playerId)
      return player
    }
    LogUtils.d(this.TAG, `No AVPlayer instance found for playerId=${playerId}.`);
    return undefined
  }

  private initMediaPlayer(mediaPlayerId: number, mediaPlayer: media.AVPlayer) {
    mediaPlayer.on('stateChange', async (state, reason) => {
      switch (state) {
        case 'idle': {
          LogUtils.e(this.TAG, 'state idle called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.IDLE)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'initialized': {
          LogUtils.e(this.TAG, 'initialized prepared called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.PREPARING)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'prepared': {
          LogUtils.e(this.TAG, 'state prepared called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.PREPARED)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'playing': {
          LogUtils.e(this.TAG, 'state playing called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.PREPARING)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'paused': {
          LogUtils.e(this.TAG, 'state paused called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.PAUSED)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'completed': {
          LogUtils.e(this.TAG, 'state completed called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.PLAYBACK_COMPLETED)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'stopped': {
          LogUtils.e(this.TAG, 'state stopped called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.STOP)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'released': {
          LogUtils.e(this.TAG, 'state released called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.RELEASE)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        case 'error': {
          LogUtils.e(this.TAG, 'state error called')
          const map = new Map<string, HippyAny>()
          map.set(QTPlayerEventProp.PLAYER_ID, mediaPlayerId)
          map.set(QTPlayerEventProp.PLAYER_STATE, QTPlayerState.ERROR)
          this.dispatchEvent(QTPlayerEvent.ON_PLAYER_STATUS_CHANGED, map)
          break;
        }
        default: {
          LogUtils.e(this.TAG, 'unkown state :' + state)
          break;
        }
      }
    })
  }
}
