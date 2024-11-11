use zed::serde_json;
use zed_extension_api::{
    self as zed,
    lsp::{Completion, CompletionKind, Symbol, SymbolKind},
    settings::LspSettings,
    CodeLabel, CodeLabelSpan, LanguageServerId, Result,
};

struct SorbetExtension;

struct SorbetBinary {
    path: String,
    args: Option<Vec<String>>,
}

impl SorbetExtension {
    fn language_server_binary(
        &self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<SorbetBinary> {
        let binary_settings =
            LspSettings::for_worktree(language_server_id.to_string().as_str(), worktree)
                .ok()
                .and_then(|lsp_settings| lsp_settings.binary);

        let default_binary_args = Some(
            vec![
                "tc",
                "--lsp",
                "--enable-experimental-lsp-document-highlight",
            ]
            .iter()
            .map(|s| s.to_string())
            .collect(),
        );

        let binary_args = binary_settings
            .as_ref()
            .and_then(|binary_settings| binary_settings.arguments.clone())
            .or(default_binary_args);

        if let Some(path) = binary_settings.and_then(|binary_settings| binary_settings.path) {
            return Ok(SorbetBinary {
                path,
                args: binary_args,
            });
        }

        if let Some(path) = worktree.which("srb") {
            return Ok(SorbetBinary {
                path,
                args: binary_args,
            });
        }

        Err("srb gem must be installed manually. Install it with `gem install sorbet`.".to_string())
    }
}

impl zed::Extension for SorbetExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let binary = self.language_server_binary(language_server_id, worktree)?;

        Ok(zed::Command {
            command: binary.path,
            args: binary.args.unwrap_or_default(),
            env: worktree.shell_env(),
        })
    }

    fn label_for_symbol(
        &self,
        _language_server_id: &LanguageServerId,
        symbol: Symbol,
    ) -> Option<CodeLabel> {
        let name = &symbol.name;

        match symbol.kind {
            SymbolKind::Method => {
                let code = format!("def {name}; end");
                let filter_range = 0..name.len();
                let display_range = 4..4 + name.len();

                Some(CodeLabel {
                    code,
                    spans: vec![CodeLabelSpan::code_range(display_range)],
                    filter_range: filter_range.into(),
                })
            }
            SymbolKind::Class | SymbolKind::Module => {
                let code = format!("class {name}; end");
                let filter_range = 0..name.len();
                let display_range = 6..6 + name.len();

                Some(CodeLabel {
                    code,
                    spans: vec![CodeLabelSpan::code_range(display_range)],
                    filter_range: filter_range.into(),
                })
            }
            SymbolKind::Constant => {
                let code = name.to_uppercase().to_string();
                let filter_range = 0..name.len();
                let display_range = 0..name.len();

                Some(CodeLabel {
                    code,
                    spans: vec![CodeLabelSpan::code_range(display_range)],
                    filter_range: filter_range.into(),
                })
            }
            _ => None,
        }
    }

    fn label_for_completion(
        &self,
        _language_server_id: &LanguageServerId,
        completion: Completion,
    ) -> Option<CodeLabel> {
        let highlight_name = match completion.kind? {
            CompletionKind::Class | CompletionKind::Module => "type",
            CompletionKind::Constant => "constant",
            CompletionKind::Method => "function.method",
            CompletionKind::Reference => "function.method",
            CompletionKind::Keyword => "keyword",
            _ => return None,
        };

        let len = completion.label.len();
        let name_span = CodeLabelSpan::literal(completion.label, Some(highlight_name.to_string()));

        Some(CodeLabel {
            code: Default::default(),
            spans: vec![name_span],
            filter_range: (0..len).into(),
        })
    }

    fn language_server_initialization_options(
        &mut self,
        language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<serde_json::Value>> {
        let initialization_options =
            LspSettings::for_worktree(language_server_id.as_ref(), worktree)
                .ok()
                .and_then(|lsp_settings| lsp_settings.initialization_options.clone())
                .unwrap_or_default();

        Ok(Some(serde_json::json!(initialization_options)))
    }
}

zed::register_extension!(SorbetExtension);
