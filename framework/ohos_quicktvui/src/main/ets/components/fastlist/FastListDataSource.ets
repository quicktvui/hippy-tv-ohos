/*
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2022 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import {HippyRenderBaseView,HippyObservedArray} from 'hippy'

export class HRListDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private templates: HippyObservedArray<HippyRenderBaseView> = []
  private count: number = 0

  constructor(templates: HippyObservedArray<HippyRenderBaseView>) {
    this.templates = templates
    this.count = templates.length
    console.info('HRList', `templates total:${templates.length}, count:${this.count}`)
  }

  public getData(index: number): HippyRenderBaseView {
    return this.templates[index]
  }

  public totalCount(): number {
    return this.count
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyReload() {
    this.count = this.templates.length
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
}
