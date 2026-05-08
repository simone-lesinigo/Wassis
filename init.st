| gitHub revealGitLab store repo repositoryPath |

"Load SSH credentials for gitlab Reveal (default) and github.com"
gitHub := IceSshCredentials new
     publicKey: (FileLocator home / '.ssh/id_ed25519.pub') pathString;
     privateKey: (FileLocator home / '.ssh/id_ed25519') pathString;
     keyPassphrase: '';
     host: 'github.com';
     username: 'simone-lesinigo';
     yourself.

revealGitLab := IceSshCredentials new
     publicKey: (FileLocator home / '.ssh/id_ed25519.pub') pathString;
     privateKey: (FileLocator home / '.ssh/id_ed25519') pathString;
     keyPassphrase: '';
     host: 'gitlab.reveal.si.usi.ch';
     username: 'lesins';
     yourself.

store := IceCredentialStore current.
store storeCredential: gitHub forHostname: gitHub host.
store storeCredential: revealGitLab forHostname: revealGitLab host.
IceCredentialsProvider useCustomSsh: true.

repositoryPath := FileLocator localDirectory / 'iceberg' / 'simone-lesinigo' / 'wassis'.
repo := IceRepositoryCreator new
     url: 'ssh://git@gitlab.reveal.si.usi.ch:60022/students/2026/simone-lesinigo/wassis.git';
     location: repositoryPath asFileReference;
     createRepository.
repo register.

Metacello new
     baseline: 'Wassis';
     repository: 'gitlocal://', repositoryPath pathString, '/src';
     load.

Smalltalk snapshot: true andQuit: true.
