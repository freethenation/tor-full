tor-full Cookbook
============
Installs and configures tor on a node

Requirements
------------
Depends on `tor` package on debian or ubuntu and `tor-core` on centos and redhat

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### tor::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['tor']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### tor::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `tor` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[tor]"
  ]
}
```
