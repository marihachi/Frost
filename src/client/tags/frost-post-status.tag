<frost-post-status>
	<div class='side'><div class='icon' ref='icon'></div></div>
	<div class='main'>
		<div class='info'>
			<a href={ '/users/' + opts.status.user.screenName }>{ opts.status.user.name } @{ opts.status.user.screenName }</a>
			<time datetime={ getTime().format() } title={ getTime().format() }>{ getTime().fromNow() }</time>
		</div>
		<div class='text' ref='text'></div>
	</div>

	<style>
		@import "../styles/variables";

		:scope {
			display: flex;
			margin: 1rem 0;

			> .side {
				> .icon {
					margin-right: 0.8rem;
					background-color: hsla(0, 0%, 0%, 0.05);
					/* background-image: url(); */
					/* background-size: cover; */
					min-height: 3.75rem;
					min-width: 3.75rem;
					border-radius: 6px;
				}
			}

			> .main {
				width: 100%;
				word-break: break-word;

				> .info {
					display: flex;
					justify-content: space-between;

					> a {
						// テキストを上に詰める
						line-height: 100%;
						text-decoration-line: none;

						// テキストの省略
						overflow: hidden;
						text-overflow: ellipsis;
						white-space: nowrap;
					}

					> time {
						color: $sub-text-color;
						font-size: 0.9rem;

						// 幅固定
						flex-shrink: 0;
					}
				}

				> .text {
					> p {
						margin-bottom: 0;
						
						.stroke {
						        text-decoration: line-through;
						}
						
						.underline {
						        text-decoration: underline;
						}
					}
				}
			}
		}
	</style>

	<script>
		this.moment = require('moment');

		getTime() {
			this.moment.locale("ja");
			return this.moment.unix(this.opts.status.createdAt);
		}

		compileText(text) {
			let compiledText = '<p>';

			compiledText += text
				.replace(/&/g, '&amp;')
				.replace(/</g, '&lt;')
				.replace(/>/g, '&gt;')
				.replace(/'/g, '&#039;')
				.replace(/"/g, '&quot;')
				.replace(/((https?|ftp):\/\/[^\s/$.?#].[^\s]*)/ig, '<a href=\'$1\' target=\'_blank\'>$1</a>') // url
				.replace(/\*\*([^\n]+?)\*\*/g, '<strong>$1</strong>') // 太字
				.replace(/\*([^\n]+?)\*/g, '<i>$1</i>') // 斜体
			        .replace(/~~([^\n]+?)~~/g, '<span class="stroke">$1</span>') // 取消線
				.replace(/__([^\n]+?)__/g, '<span class="underline">$1</span>') // 下線
				.replace(/`([^\n]+?)`/g, '<code>$1</code>') // コード
				.replace(/`/g, '&#x60;')
				.replace(/\n/g, '</p><p>'); // 改行

			compiledText += '</p>';

			return compiledText;
		}
		
		updateIcon() {
			this.refs.icon.style.backgroundImage = `url(https://placeimg.com/${this.refs.icon.offsetWidth * window.devicePixelRatio}/${this.refs.icon.offsetHeight * window.devicePixelRatio}/people/grayscale?${opts.status.user.screenName})`;
		}

		onResize() {
			if (this.width == window.innerWidth) return;
			this.width = window.innerWidth;
			this.updateIcon();
		}
		
		this.on('mount', () => {
			this.refs.text.innerHTML = this.compileText(this.opts.status.text);
			
			updateIcon();
			this.width = window.innerWidth;
			window.addEventListener('resize', this.onResize);

			// 定期的に画面を更新
			setInterval(() => {
				this.update();
			}, 60 * 1000);
		});

		this.on('unmount', () => {
			window.removeEventListener('resize', this.onResize);
		});
	</script>
</frost-post-status>
