<frost-logout-button>
	<button type='button' onclick={signout}>Logout</button>

	<script>
		import fetchJson from '../scripts/fetch-json';
		this.csrfToken = document.getElementsByName('_csrf').item(0).content;

		this.signout = () => {
			fetchJson('DELETE', '/session', {
				_csrf: this.csrfToken
			}).then((res) => {
				document.cookie = 'sid=; max-age=0';
				location.reload();
			})
			.catch(reason => {
				console.log('Sign out error: ' + reason);
			});
		};
	</script>
</frost-logout-button>
