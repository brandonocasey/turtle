'no packages: calls prefix and config get'

'one package'
'one package and --save:  calls config set'
'one package and --save-dev: calls config set'
'one package and --save-optional calls config set'

'two packages'
'two packages and --save:  calls config set'
'two packages and --save-dev: calls config set'
'two packages and --save-optional calls config set'

'one package with version'
'one package with version and --save:  calls config set'
'one package with version and --save-dev: calls config set'
'one package with version and --save-optional calls config set'

'two packages with version'
'two packages with version and --save:  calls config set'
'two packages with version and --save-dev: calls config set'
'two packages with version and --save-optional calls config set'

'Fail: check remote for pkg once then success'
'Fail: check remote for pkg twice then success'

'Fail: check remote for pkg three(all) times then fail'
'Fail: cannot download package after check remote'
'Fail: cannot download files from files array'

'Fail: check remote with --save no config set'
'Fail: check remote with --save-dev no config set'
'Fail: check remote with --save-optional no config set'

'Fail: download --save no config set'
'Fail: download --save-dev no config set'
'Fail: download --save-optional no config set'

'Fail: files download --save no config set'
'Fail: files download --save-dev no config set'
'Fail: files download --save-optional no config set'

