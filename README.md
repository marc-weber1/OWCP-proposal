# Online World Communication Protocol

## Channels

Channels are continuously sent packets, which may be client -> server, server -> client, both directions, or client -> client (which support P2P communication or packet relaying). All may be declared as required, optional, or unsupported by the server. Required channels must be opened by the client, optional channels may be opened, and unsupported channels must not be opened.

This protocol is designed to support VR clients, XR clients, desktop clients, and even potentially voice or text only clients.

### Voice (unreliable)

client -> client voice packets, encoded in opus.

### Bones (unreliable)

client -> client updates on the position and rotation of bones on your avatar's skeleton. VR/XR clients could provide these updates with an IK solver, a video to skeleton computer vision algorithm, or even full body motion capture. Desktop clients can provide these updates with animations.

### Blendshapes (unreliable)

client -> client updates that set the value of a blendshape on your current avatar. VR/XR clients can provide these updates with gestures (i.e. puppeting blendshapes with the controllers), face tracking, and other control mechanisms. All clients with a microphone can use microphone vowel/consonant detection to update facial blendshapes.

### Position (see description)

The 3D position of your character in the world. This could be client -> client, client -> server, or in the case of a game world server authoritative, potentially even with a rollback netcode. This includes jumping (?)

## Events

Events are more infrequent, reliable packets that do not require any kind of continuously open connection.

### World Loading

Worlds should be in GLTF format with GLTF extensions and OMI extensions. Servers and clients should both filter worlds for potential attack vectors.

`on_world_change(url)` server -> client

`on_world_change(file)` server -> client

`request_world_change(url)` client -> server

`request_world_change(file)` client -> server

### Avatar Change

Avatars should be in VRM 1.0 format. Clients should filter avatars for potential attack vectors.

`peer_changed_avatar(file)` client -> client

### Height Change

Some servers may want to restrict height, so this will be a server-authoritative value. Servers may not even listen to height change requests.

`on_height_change(float)` server -> client

`request_height_change(float)` client -> server

### Standard Interactions

Interactions should be compatible with every VR/XR controller, and a mouse. Interaction with a VR controller is typically the trigger button. Hand tracking clients could provide an interface that detects e.g. when you are poking an object or grabbing it.

Support for server-defined custom interactions should be figured out at some point in the future.

`interact()` client -> server

`grab()` client -> server

### Playspace Change

Playspace updates should be in an extensionless GLTF (?) format. This is primarily a way for XR clients to describe the client's current space to the server, but can also be used with VR clients to describe an oculus guardian or valve boundary. The GLTF file should contain the playspace data as geometry.

`update_playspace(file)` client -> server
