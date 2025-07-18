<template>
  <div class="full-node-stake-tab">
    <div class="q-pa-md">
      <div class="row align-items sn-contribution-info">
        <div class="col-md-8">
          <div class="header">{{ $t("titles.availableForContribution") }}</div>
        </div>
        <div class="col-md-4">
          <q-btn
            class="float-right vertical-top"
            icon="refresh"
            flat
            @click="updateFullNodeList"
          />
        </div>
      </div>
      <div v-if="awaitingFullNodes.length > 0">
        <FullNodeList
          v-if="awaitingFullNodes"
          :full-nodes="awaitingFullNodes"
          button-i18n="buttons.stake"
          :details="details"
          :action="contributeToNode"
        />
      </div>
      <div v-else>{{ $t("strings.noFullNodesCurrentlyAvailable") }}</div>
    </div>
    <FullNodeDetails
      ref="fullNodeDetailsContribute"
      :action="contributeToNode"
      action-i18n="buttons.stake"
    />
    <q-inner-loading :showing="fetching" :dark="theme == 'dark'">
      <q-spinner color="primary" size="30" />
    </q-inner-loading>
  </div>
</template>

<script>
import { mapState } from "vuex";
import FullNodeList from "./full_node_list";
import FullNodeDetails from "./full_node_details";
export default {
  name: "FullNodeContribute",
  components: {
    FullNodeList,
    FullNodeDetails
  },
  props: {
    awaitingFullNodes: {
      type: Array,
      required: true
    }
  },
  computed: mapState({
    theme: state => state.gateway.app.config.appearance.theme,
    fetching: state => state.gateway.daemon.full_nodes.fetching
  }),
  methods: {
    scrollToTop() {
      window.scrollTo(0, 0);
    },
    contributeToNode(node, event) {
      // stop detail page from popping up
      event.stopPropagation();
      this.scrollToTop();
      const key = node.full_node_pubkey;
      const minContribution = node.minContribution;
      // close the detail popup if it's open
      this.$refs.fullNodeDetailsContribute.isVisible = false;
      this.$emit("contribute", key, minContribution);
      this.$q.notify({
        type: "positive",
        timeout: 1000,
        message: this.$t("notification.positive.fullNodeInfoFilled")
      });
    },
    details(node) {
      this.$refs.fullNodeDetailsContribute.isVisible = true;
      this.$refs.fullNodeDetailsContribute.node = node;
    },
    updateFullNodeList() {
      this.$gateway.send("wallet", "update_full_node_list");
    }
  }
};
</script>

<style lang="scss">
.sn-contribution-info {
  > * {
    line-height: 30px;
    margin: 20 400;
  }
  margin-bottom: 6px;
}
</style>
