# Deploy Checklist

## Every deploy

- [ ] Sync `deploy/` from the parent folder's current kit files
- [ ] Bump `?v=YYYYMMDD` in `build.xslt` for every file that changed
- [ ] Import Current in the Branding Editor (copies /shared → /dev)
- [ ] Upload changed files to `/dev`
- [ ] Preview a real form in the **test instance**
- [ ] Publish (copies /dev → /shared/)
- [ ] Spot-check a production form in incognito (bypasses browser cache)
- [ ] Allow up to 15 min for server-side cache propagation

## Yearly

- [ ] Update the hardcoded © year in `build.xslt` footer
- [ ] Review token values against any brand.wsu.edu updates
- [ ] Check the Slate Knowledge Base for new `--fw-*` variables

## Occasional

- [ ] Re-run `cd docs-generator && dotnet run` to regenerate `usermanual.md`
- [ ] Verify GTM scripts still exist in `/shared/` after any file cleanup
- [ ] Re-check mobile template pointer: Database ▸ Configuration Keys ▸
      Branding, Privacy, & Ping ▸ Mobile Template → `/shared/build.xslt`
