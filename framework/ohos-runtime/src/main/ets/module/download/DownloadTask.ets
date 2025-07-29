import { Download } from "./Download";
import { DownloadProgressListener, DownloadStatusListener } from "./DownloadListener";
import request from '@ohos.request';
import { DownloadStatus } from "./DownloadStatus";
import { DownloadProgress } from "./DownloadProgress";
import { DownloadState } from "./DownloadState";
import { DownloadMessage } from "./DownloadMessage";

/**
 * 下载任务
 */
export class DownloadTask {
  //
  private context: Context;
  private downloadTask: request.agent.Task | null = null
  private downloadInfo: Download | null = null;
  private downloadStatusListener: DownloadStatusListener | null = null;
  private downloadProgressListener: DownloadProgressListener | null = null

  public constructor(context: Context) {
    this.context = context
  }

  getDownload(): Download | null {
    return this.downloadInfo
  }

  async download(download: Download) {
    this.downloadInfo = download
    const url = download.fileUrl
    const path = download.downloadPath
    const config: request.agent.Config = {
      action: request.agent.Action.DOWNLOAD,
      url,
      method: 'GET',
      title: 'download',
      mode: request.agent.Mode.BACKGROUND,
      network: request.agent.Network.ANY,
      saveas: path,
      overwrite: true,
      gauge: true
    };
    //
    this.downloadTask = await request.agent.create(this.context, config);

    //
    this.downloadTask.on('progress', (progress: request.agent.Progress) => {
      let processed = Number(progress.processed.toString()).valueOf();
      let size = progress.sizes[0];
      let process: number = Math.floor(processed / size * 100);

      if (this.downloadProgressListener) {
        const progress: DownloadProgress = {
          downloadSize: processed,
          totalSize: size,
          progress: process
        }
        const status: DownloadStatus<DownloadProgress> = {
          state: DownloadState.DOWNLOAD_STATE_PROGRESS,
          download: this.downloadInfo,
          data: progress
        }
        this.downloadProgressListener(status)
      }
    })
    //
    this.downloadTask.on('completed', async (progress: request.agent.Progress) => {
      if (this.downloadStatusListener) {
        const status: DownloadStatus<DownloadMessage> = {
          state: DownloadState.DOWNLOAD_STATE_SUCCESS,
          download: this.downloadInfo,
          data: null
        }
        this.downloadStatusListener(status)
      }
      await this.cancel()
    })
    //
    this.downloadTask.on('failed', async (progress: request.agent.Progress) => {
      if (this.downloadTask) {
        let taskInfo = await request.agent.show(this.downloadTask.tid);

        if (this.downloadStatusListener) {
          const message: DownloadMessage = {
            message: taskInfo.reason,
            code: -1
          }
          const status: DownloadStatus<DownloadMessage> = {
            state: DownloadState.DOWNLOAD_STATE_ERROR,
            download: this.downloadInfo,
            data: message
          }
          this.downloadStatusListener(status)
        }

        await this.cancel()
      }
    })
  }

  async start() {
    if (this.downloadTask) {
      await this.downloadTask.start();
    }
  }

  async stop() {
    if (this.downloadTask) {
      await this.downloadTask.stop();
    }
  }

  async pause() {
    if (this.downloadTask) {
      await this.downloadTask.pause();
    }
  }

  async resume() {
    if (this.downloadTask) {
      await this.downloadTask.resume();
    }
  }

  async cancel() {
    if (this.downloadTask) {
      this.downloadTask.off('progress');
      this.downloadTask.off('completed');
      this.downloadTask.off('failed');
      await request.agent.remove(this.downloadTask.tid);
    }
  }

  async release() {
    this.downloadStatusListener = null
  }

  setDownloadStatusListener(downloadStatusListener: DownloadStatusListener): void {
    this.downloadStatusListener = downloadStatusListener
  }

  setDownloadProgressListener(downloadProgressListener: DownloadProgressListener): void {
    this.downloadProgressListener = downloadProgressListener
  }
}
